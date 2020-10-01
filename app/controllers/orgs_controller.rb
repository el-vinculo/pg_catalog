class OrgsController < ApplicationController
  before_action :set_org, only: [:show, :edit, :update, :destroy]

  # GET /orgs
  # GET /orgs.json
  def index
    @orgs = Org.all
  end

  # GET /orgs/1
  # GET /orgs/1.json
  def show
  end

  # GET /orgs/new
  def new
    @org = Org.new
  end

  # GET /orgs/1/edit
  def edit
  end

  # POST /orgs
  # POST /orgs.json
  def create
    @org = Org.new(org_params)

    respond_to do |format|
      if @org.save
        format.html { redirect_to @org, notice: 'Org was successfully created.' }
        format.json { render :show, status: :created, location: @org }
      else
        format.html { render :new }
        format.json { render json: @org.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orgs/1
  # PATCH/PUT /orgs/1.json
  def update
    respond_to do |format|
      if @org.update(org_params)
        format.html { redirect_to @org, notice: 'Org was successfully updated.' }
        format.json { render :show, status: :ok, location: @org }
      else
        format.html { render :edit }
        format.json { render json: @org.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orgs/1
  # DELETE /orgs/1.json
  def destroy
    @org.destroy
    respond_to do |format|
      format.html { redirect_to orgs_url, notice: 'Org was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_new_entry
    logger.debug("the parameters are #{params}")

    dyna_entry = params["catalog"]
    existing_org = Org.find_by_domain(dyna_entry["url"])

    if existing_org.nil?
      org = Org.new
    else
      logger.debug("****** THE ORG EXISTS")
      org = existing_org

    end
    org.name = dyna_entry["OrganizationName"]["OrganizationName"][0]["Text"] if dyna_entry["OrganizationName"]["OrganizationName"][0]["Text"]
    org.domain = dyna_entry["url"]
    org.description_display = dyna_entry["OrganizationName"]["OrganizationDescriptionDisplay"] if dyna_entry["OrganizationName"]["OrganizationDescriptionDisplay"]
    org.org_type = dyna_entry["OrganizationName"]["Type"] if dyna_entry["OrganizationName"]["Type"]
    org.home_url = dyna_entry["OrganizationName"]["HomePageURL"] if dyna_entry["OrganizationName"]["HomePageURL"]
    org.inactive = dyna_entry["OrganizationName"]["InactiveCatalog"] if dyna_entry["OrganizationName"]["InactiveCatalog"]
    if org.save
      grabbed_org_desc = dyna_entry["OrganizationName"]["OrgDescription"]

      if grabbed_org_desc
        grabbed_org_desc.each do |god|
          if !god.empty?
            GrabList.create(field_name: "OrganizationDescription", text: god["Text"], xpath: god["Xpath"],
                            page_url: god["Domain"], org: org)
          end
        end
      end

      grabbed_org_name = dyna_entry["OrganizationName"]["OrganizationName"][0]
      if !grabbed_org_name.empty?
        GrabList.create(field_name: "OrganizationName", text: grabbed_org_name["Text"], xpath: grabbed_org_name["Xpath"],
                        page_url: grabbed_org_name["Domain"], org: org)
      end

      #Code to extract sites data into postgrace
      if dyna_entry["OrgSites"]
        dyna_entry["OrgSites"].each do |site|
          extract_site_data(site, org)
        end
      end

      #Code to extract program data into postgrace
      if dyna_entry["Programs"]
        dyna_entry["Programs"].each do |p|
          extract_programs_data(p,org, dyna_entry)
        end
      end

      if dyna_entry["GeoScope"]
        extract_geo_scope_data(dyna_entry["GeoScope"], org)
      end

    end

  end


  def update_sites
    dyna_entry = params["catalog"]
    org = Org.find_by_domain(dyna_entry["url"])
    sites = dyna_entry["sites"]

    sites.each do |site|
      existing_site = Site.where(["org_id = ? and site_name = ?", org.id, site["LocationName"]])
      if existing_site.empty?
        s = Site.new
      else
        s = existing_site.first
      end
      s.site_name = site["LocationName"] if site["LocationName"]
      s.site_url = site["Webpage"] if site["Webpage"]
      s.site_ref = site["Referrals"] if site["Referrals"]
      s.admin = site["AdminSite"] if site["AdminSite"]
      s.delivery = site["ServiceDeliverySite"] if site["ServiceDeliverySite"]
      s.resource_dir = site["ResourceDirectory"] if site["ResourceDirectory"]
      s.inactive = site["InactiveSite"] if site["InactiveSite"]
      s.org_id = org.id
      if s.save
        create_location(s, site)
        create_poc(s,site,org)
      else
        logger.debug("******the error in s save is : #{s.errors.full_messages}")
      end
    end






  end


  def update_programs

    dyna_entry = params["catalog"]
    org = Org.find_by_domain(dyna_entry["url"])
    programs = dyna_entry["programs"]

    programs.each do |p|
      logger.debug("the program is : #{p}--------- org is #{org.id} ")

      program_check = Program.where(["org_id = ? and name = ?", org.id, p["ProgramName"]])

      if program_check.nil?
        prgm = Program.new
      else
        prgm = program_check.first
      end

      prgm.name = p["ProgramName"] if p["ProgramName"]
      prgm.quick_url = p["QuickConnectWebPage"] if p["QuickConnectWebPage"]
      prgm.contact_url = p["ContactWebPage"] if p["ContactWebPage"]
      prgm.program_url = p["ProgramWebPage"] if p["ProgramWebPage"]
      prgm.program_description_display = p["ProgramDescriptionDisplay"] if p["ProgramDescriptionDisplay"]
      prgm.population_description_display = p["PopulationDescriptionDisplay"] if p["PopulationDescriptionDisplay"]
      prgm.service_area_description_display = p["ServiceAreaDescriptionDisplay"] if p["ServiceAreaDescriptionDisplay"]
      prgm.inactive = p["InactiveProgram"] if p["InactiveProgram"]
      prgm.org_id = org.id
      if prgm.save
        attached_sites = p["ProgramSites"]
        program_sites = ProgramSite.where(program_id: prgm.id)
        program_sites.each do |ps|
          ps.destroy
        end
        if p.key?("ProgramSites")
          attached_sites.each do |site|
            entry = dyna_entry["dyna_entry"]["OrgSites"].select{|o| o["SelectSiteID"] == site}
            logger.debug("the selected entry is : #{entry}, site id is : #{site}")
            name = entry[0].nil? ? "" : entry[0]["LocationName"]
            logger.debug("@@@@@@@@@@@@@@@@@ the name of the location is : #{name}")
            if !name.blank?
              s = Site.where(["org_id = ? and site_name = ?", org.id, name]).first
              logger.debug(".>>>>>>>>>>**************the sete you are looking for is : #{s}")
              ps = ProgramSite.new
              ps.site =  s
              ps.program = prgm
              if ps.save
              else
                logger.debug("ps is not saving because : #{ps.errors.full_messages}")
              end
            end
          end
        end
      end

      create_groups(p, prgm, org)
      service_tags = p["ServiceTags"].split(", ")
      service_tag_list = ServiceTag.all.pluck("name")
      service_tags.each do|st|
        if !service_tag_list.include? (st)
          ServiceTag.create(name: st)
        end
        selected_tag = ServiceTag.find_by_name(st)
        if ProgramServiceTag.where(["program_id = ? and service_tag_id = ?", prgm.id, selected_tag.id]).empty?
          ProgramServiceTag.create(org: org, program: prgm, service_tag: selected_tag)
        end
      end

      p.each do |key,value|
        if ["ProgramDescription", "PopulationDescription", "ServiceAreaDescription" ].include? (key)

          value.each do |grabbed_field|
            if GrabList.where(["field_name = ? and program_id = ?", key, prgm.id]).empty?

                GrabList.create(field_name: key , text: grabbed_field["Text"], xpath: grabbed_field["Xpath"],
                                page_url: grabbed_field["Domain"], org: org, program_id: prgm.id)
            else
              GrabList.where(["field_name = ? and program_id = ?", key, prgm.id]).first.update(field_name: key ,
                                                                                               text: grabbed_field["Text"],
                                                                                               xpath: grabbed_field["Xpath"],
                                                                                               page_url: grabbed_field["Domain"],
                                                                                               org: org, program_id: prgm.id)
            end
          end
        end
      end
    end



  end

  def extract_geo_scope_data(data, org)
    existing_scope = org.scopes
    if existing_scope.empty?
      scope = Scope.new
    else
      logger.debug("***********the SCOPE ALREADY EXISTS***************")
      scope = existing_scope.first  
    end
    scope.geo_scope = data["Scope"] if data["Scope"]
    scope.neigborhood = data["Neighborhoods"] if data["Neighborhoods"]
    scope.city = data["City"] if data["City"]
    scope.county = data["County"] if data["County"]
    scope.state = data["State"] if data["State"]
    scope.region = data["Region"] if data["Region"]
    scope.country = data["Country"] if data["Country"]
    scope.inactive = data["InactiveCatalog"] if data["InactiveCatalog"]
    scope.org_id = org.id
    scope.save
  end

  def create_groups(p, prgm,org)
    all_servicegroup_list = ServiceGroup.all.pluck("name")
    all_popgroup_list = PopulationGroup.all.pluck("name")
    ProgramServiceGroup.where(program_id: prgm.id).each do |psg|
      psg.destroy
    end

    ProgramPopulationGroup.where(program_id: prgm.id).each do |ppg|
      ppg.destroy
    end

    p.each do |key,value|
        if key[0..1] == "S_"
          name = key.split("_")[1]
          if !all_servicegroup_list.include? (name)
            sg = ServiceGroup.create(name: name)
          end
          if value == true
            selected_sg = ServiceGroup.find_by_name(name)
            ProgramServiceGroup.create(org: org, program: prgm, service_group: selected_sg)
          end
        elsif key[0..1] == "P_"
          name = key.split("_")[1]
          if !all_popgroup_list.include? (name)
            pg = PopulationGroup.create(name: name)
          end
          if value == true
            selected_pg = PopulationGroup.find_by_name(name)
            ProgramPopulationGroup.create(org: org, program: prgm, population_group: selected_pg)
          end
        end
    end
  end

  def extract_programs_data(p,org, dyna_entry)

    existing_prgm = Program.where(["org_id = ? and name = ?", org.id, p["ProgramName"]])

    if existing_prgm.empty?
      prgm = Program.new
    else
      prgm = existing_prgm.first
    end

    prgm.name = p["ProgramName"] if p["ProgramName"]
    prgm.quick_url = p["QuickConnectWebPage"] if p["QuickConnectWebPage"]
    prgm.contact_url = p["ContactWebPage"] if p["ContactWebPage"]
    prgm.program_url = p["ProgramWebPage"] if p["ProgramWebPage"]
    prgm.program_description_display = p["ProgramDescriptionDisplay"] if p["ProgramDescriptionDisplay"]
    prgm.population_description_display = p["PopulationDescriptionDisplay"] if p["PopulationDescriptionDisplay"]
    prgm.service_area_description_display = p["ServiceAreaDescriptionDisplay"] if p["ServiceAreaDescriptionDisplay"]
    prgm.inactive = p["InactiveProgram"] if p["InactiveProgram"]
    prgm.org_id = org.id
    if prgm.save
      attached_sites = p["ProgramSites"]
      program_sites = ProgramSite.where(program_id: prgm.id)
      program_sites.each do |ps|
        ps.destroy
      end
      if p.key?("ProgramSites")
        attached_sites.each do |site|
          entry = dyna_entry["OrgSites"].select{|o| o["SelectSiteID"] == site}
          logger.debug("the selected entry is : #{entry}, site id is : #{site}")
          name = entry[0].nil? ? "" : entry[0]["LocationName"]
          logger.debug("@@@@@@@@@@@@@@@@@ the name of the location is : #{name}")
          if !name.blank?
            s = Site.where(["org_id = ? and site_name = ?", org.id, name]).first
            logger.debug(".>>>>>>>>>>**************the sete you are looking for is : #{s}")
            ps = ProgramSite.new
            ps.site =  s
            ps.program = prgm
            if ps.save
            else
              logger.debug("ps is not saving because : #{ps.errors.full_messages}")
            end
          end
        end
      end

      create_groups(p, prgm, org)
      service_tags = p["ServiceTags"].split(", ")
      service_tag_list = ServiceTag.all.pluck("name")
      service_tags.each do|st|
        if !service_tag_list.include? (st)
          ServiceTag.create(name: st)
        end
        selected_tag = ServiceTag.find_by_name(st)
        if ProgramServiceTag.where(["program_id = ? and service_tag_id = ?", prgm.id, selected_tag.id]).empty?
          ProgramServiceTag.create(org: org, program: prgm, service_tag: selected_tag)
        end
      end


      p.each do |key,value|
        if ["ProgramDescription", "PopulationDescription", "ServiceAreaDescription" ].include? (key)

          value.each do |grabbed_field|
            if GrabList.where(["field_name = ? and program_id = ?", key, prgm.id]).empty?

              GrabList.create(field_name: key , text: grabbed_field["Text"], xpath: grabbed_field["Xpath"],
                              page_url: grabbed_field["Domain"], org: org, program_id: prgm.id)
            else
              GrabList.where(["field_name = ? and program_id = ?", key, prgm.id]).first.update(field_name: key ,
                                                                                               text: grabbed_field["Text"],
                                                                                               xpath: grabbed_field["Xpath"],
                                                                                               page_url: grabbed_field["Domain"],
                                                                                               org: org, program_id: prgm.id)
            end
          end
        end
      end
      # value.each do |grabbed_field|
      #   GrabList.create(field_name: key , text: grabbed_field["Text"], xpath: grabbed_field["Xpath"],
      #                   page_url: grabbed_field["Domain"], org: org, program_id: prgm.id)
      # end

    end
  end

  def extract_site_data(site, org)

    existing_site = Site.where(["org_id = ? and site_name = ?", org.id, site["LocationName"]])
    if existing_site.empty?
      s = Site.new
    else
      s = existing_site.first
    end
    s.site_name = site["LocationName"] if site["LocationName"]
    s.site_url = site["Webpage"] if site["Webpage"]
    s.site_ref = site["Referrals"] if site["Referrals"]
    s.admin = site["AdminSite"] if site["AdminSite"]
    s.delivery = site["ServiceDeliverySite"] if site["ServiceDeliverySite"]
    s.resource_dir = site["ResourceDirectory"] if site["ResourceDirectory"]
    s.inactive = site["InactiveSite"] if site["InactiveSite"]
    s.org_id = org.id
    if s.save
      create_location(s, site)
      create_poc(s,site,org)
    else
      logger.debug("******the error in s save is : #{s.errors.full_messages}")
    end


  end

  def create_location(s, site)

    if !site.key?("Addr1").nil? && !site["AddrCity"].nil?
      existing_loc = Location.where(["sites_id = ? and addr1 = ?", s.id, site["Addr1"][0]["Text"] ])
      if existing_loc.empty?
        loc = Location.new
      else
        loc = existing_loc.first
      end
      loc.addr1 = site.key?("Addr1") ? site["Addr1"][0]["Text"] : ""
      loc.city = site["AddrCity"] if site["AddrCity"]
      loc.state = site["AddrState"] if site["AddrState"]
      loc.zip = site["AddrZip"] if site["AddrZip"]
      loc.phone = site["OfficePhone"] if site["OfficePhone"]
      loc.email = site["Email"] if site["Email"]
      loc.primary_poc = site["DefaultPOC"] if site["DefaultPOC"]
      loc.inactive = site["InactiveSite"] if site["InactiveSite"]
      loc.sites_id = s.id
      if loc.save
      else
        logger.debug("---------------******the reasson why loc is not saving is #{loc.errors.full_messages}")
      end
    end

  end

  def create_poc(s,site,org)

    SitePoc.where(site_id: s.id).each do |sp|
      sp.destroy
    end
    if site.key?("POCs")
      site["POCs"].each do |contact|
        existing_poc = Poc.where(["org_id = ? and poc_name = ?", org.id, contact["poc"]["Name"]])
        if existing_poc.empty?
          poc = Poc.new
        else
          poc = existing_poc.first
        end
        poc.org = org
        poc.poc_name = contact["poc"]["Name"]
        poc.title = contact["poc"]["Title"]
        poc.work = contact["poc"]["OfficePhone"]
        poc.email = contact["poc"]["Email"]
        poc.inactive = contact["poc"]["InactivePOC"]
        if poc.save
          SitePoc.create(poc: poc, site: s)
        end
      end
    end
    
  end



  def catalog_search

    #--- {'population': {'conditional': 'OR', 'value': ['P_Citizenship']},
    #---  'services': {'type': 'group', 'conditional': 'OR', 'value': ['S_Clothing']},
    #---+++  'name': 'YWCA Kitsap County',
    #---+++  'tags': ['Repair'],
    #---  'GeoScope': {'value': 'WA', 'type': 'State'},
    #  'application_name': 'demo'}
    # {'GeoScope': {'value': 'National', 'type': 'Scope'}, 'application_name': 'demo'}

    query_params = params["search_params"].keys
    all_acttive_programs = Program.where(inactive: nil)
    logger.debug("query_params iss : #{query_params}")
    if query_params.sort == ["application_name"].sort
      logger.debug("ONLY application")
      all_programs = all_acttive_programs

    elsif query_params.sort == ["tags","application_name"].sort
      logger.debug("*********IN THE TAGS")
      tags = params["search_params"]["tags"]
      all_programs = filter_tags(tags,all_acttive_programs)
      # all_programs = Program.joins(:service_tags).where(service_tags: {name: tags}, inactive: nil)

    elsif query_params.sort == ["population","application_name"].sort
      logger.debug("*********IN the population")
      population_groups = params["search_params"]["population"]["value"]
      # all_programs = Program.joins(:population_groups).where(population_groups: {name: population_groups}, inactive: nil)
      all_programs = filter_population_groups(population_groups, all_acttive_programs)

    elsif query_params.sort == ["services","application_name"].sort
      logger.debug('***************IN THE SERVICES')
      service_groups = params["search_params"]["services"]["value"]
      # all_programs = Program.joins(:service_groups).where(service_groups: {name: service_groups}, inactive: nil)
      all_programs = filter_service_groups(service_groups,all_acttive_programs)

    elsif query_params.sort == ['name','application_name'].sort
      logger.debug("********IN THE NAME")
      org_name = params["search_params"]["name"]
      # all_org = Org.where("name ILike ?", "%" + org_name + "%")

      all_programs = filter_name(org_name,all_acttive_programs)

    elsif query_params.sort == ["GeoScope","application_name"].sort

      scope_value = params["search_params"]["GeoScope"]["value"]
      scope_type = params["search_params"]["GeoScope"]["type"]
      all_programs = filter_scope(scope_value, scope_type,all_acttive_programs)

    else
      logger.debug("************IN the final else")
      programs = all_acttive_programs
      if query_params.include? ('name')
        logger.debug("************IN the final else------------NAME")
        org_name = params["search_params"]["name"]
        programs = filter_name(org_name,programs)
      end
      if query_params.include? ('services')
        logger.debug("************IN the final else-----------SERVICES")
        service_groups = params["search_params"]["services"]["value"]
        programs = filter_service_groups(service_groups,programs)
      end
      if query_params.include? ('population')
        logger.debug("************IN the final else-----------POPULATION")
        population_groups = params["search_params"]["population"]["value"]
        programs = filter_population_groups(population_groups, programs)
      end
      if query_params.include? ('tags')
        logger.debug("************IN the final else-------------TAGS---#{programs.count}")
        tags = params["search_params"]["tags"]
        programs = filter_tags(tags,programs)
      end

      all_programs = programs

    end

    provider_list = split_programs(all_programs)

    render :json => {status: :ok,count: provider_list.count, provider_list: provider_list }

  end

  #---  'GeoScope': {'value': 'WA', 'type': 'State'},
  # {'GeoScope': {'value': 'National', 'type': 'Scope'}, 'application_name': 'demo'}
  def filter_scope(scope_value, scope_type, programs)
    programs_array = []

    programs.each do |p|
      if !p.org.inactive?
        prog_scope_type = p.org.scopes.first.geo_scope
        if scope_type == "State"
          prog_scope_value = p.org.scopes.first.state

        elsif scope_type == "County"
          prog_scope_value = p.org.scopes.first.county

        elsif scope_type == "City"
          prog_scope_value = p.org.scopes.first.city

        elsif scope_type == "Scope"


        end

        if ['National', 'Virtual'].include? (scope_value)

          if prog_scope_type.downcase == scope_value.downcase
            programs_array.push(p)
          end

        else
          if (prog_scope_type == scope_type) && (prog_scope_value.downcase.include? (scope_value.downcase))
            logger.debug("THE the value of the prog_scope_value: #{prog_scope_value} :: #{prog_scope_value}-------type : #{prog_scope_type} :: #{scope_type} ")
            programs_array.push(p)
          end
        end

      end
    end

    programs_array

  end

  def filter_population_groups(population_groups,programs)
    population_group_count = population_groups.count
    programs_array = []

    programs.each do |p|
      if !p.org.inactive?
        true_array = []
        population_groups.each do |pg|
          if !p.population_groups.where(name: pg).blank?
            true_array.push("true")
          end
        end
        if true_array.count == population_group_count
          programs_array.push(p)
        end
      end
    end

    programs_array
    # Program.joins(:population_groups).where(population_groups: {name: population_groups})
  end

  def split_programs(programs)
    provider_list = []
    programs.each do |p|
      org = p.org
      prog_name = p.name
      org_name = org.name
      org_domain = org.domain
      provider = {domain: org_domain ,org_name: org_name, prog_name: prog_name}
      provider_list.push(provider)

    end
    provider_list

  end

  def filter_name(name,program)
    programs_array = []
    logger.debug("**********IN the filter name #{name}")

    program.each do |p|

      if !p.org.inactive?
        if p.org.name.downcase.include?(name.downcase)
          logger.debug("****The name is a match #{p.org.name}")
          programs_array.push(p)
        end
      end
    end

    programs_array
    # Org.where("name ILike ?", "%" + name + "%")
  end

  def filter_tags(tags,programs)
    tags_count = tags.count
    programs_array = []

    programs.each do |p|
      if !p.org.inactive?
        true_array = []
        tags.each do |t|
          if !p.service_tags.where(name: t).blank?
            true_array.push("true")
          end
        end
        if true_array.count == tags_count
          programs_array.push(p)
        end
      end
    end

    programs_array
    # Program.joins(:service_tags).where(service_tags: {name: tags})
  end


  def filter_service_groups(service_groups,programs)
    service_groups_count = service_groups.count
    programs_array = []

    programs.each do |p|
      if !p.org.inactive?
        true_array = []
        service_groups.each do |sg|
          if !p.service_groups.where(name: sg).blank?
            true_array.push("true")
          end
        end
        if true_array.count == service_groups_count
          programs_array.push(p)
        end
      end
    end

    programs_array
    # Program.joins(:service_groups).where(service_groups: {name: service_groups})
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_org
      @org = Org.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def org_params
      params.require(:org).permit(:name, :description_display)
    end
end

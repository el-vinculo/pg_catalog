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
    org = Org.new

    org.name = dyna_entry["OrganizationName"]["OrganizationName"][0]["Text"] if dyna_entry["OrganizationName"]["OrganizationName"][0]["Text"]
    org.domain = dyna_entry["url"]
    org.description_display = dyna_entry["OrganizationName"]["OrganizationDescriptionDisplay"] if dyna_entry["OrganizationName"]["OrganizationDescriptionDisplay"]
    org.org_type = dyna_entry["OrganizationName"]["Type"] if dyna_entry["OrganizationName"]["Type"]
    org.home_url = dyna_entry["OrganizationName"]["HomePageURL"] if dyna_entry["OrganizationName"]["HomePageURL"]
    org.inactive = dyna_entry["OrganizationName"]["InactiveCatalog"] if dyna_entry["OrganizationName"]["InactiveCatalog"]
    if org.save
      grabbed_org_desc = dyna_entry["OrganizationName"]["OrgDescription"]
      grabbed_org_desc.each do |god|
        if !god.empty?
          GrabList.create(field_name: "OrganizationDescription", text: god["Text"], xpath: god["Xpath"],
                          page_url: god["Domain"], org: org)
        end
      end

      grabbed_org_name = dyna_entry["OrganizationName"]["OrganizationName"][0]
      if !grabbed_org_name.empty?
        GrabList.create(field_name: "OrganizationName", text: grabbed_org_name["Text"], xpath: grabbed_org_name["Xpath"],
                        page_url: grabbed_org_name["Domain"], org: org)
      end

      #Code to extract sites data into postgrace
      dyna_entry["OrgSites"].each do |site|
        extract_site_data(site, org)
      end

      #Code to extract program data into postgrace
      dyna_entry["Programs"].each do |p|
        extract_programs_data(p,org, dyna_entry)
      end

      extract_geo_scope_data(dyna_entry["GeoScope"], org)

    end

  end

  def extract_geo_scope_data(data, org)
    scope = Scope.new
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
    prgm = Program.new
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
      attached_sites.each do |site|
        entry = dyna_entry["OrgSites"].select{|o| o["SelectSiteID"] == site}
        logger.debug("the selected entry is : #{entry}, site id is : #{site}")
        name = entry[0]["LocationName"]
        logger.debug("@@@@@@@@@@@@@@@@@ the name of the location is : #{name}")
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

      create_groups(p, prgm, org)
      service_tags = p["ServiceTags"].split(", ")
      service_tag_list = ServiceTag.all.pluck("name")
      service_tags.each do|st|
        if !service_tag_list.include? (st)
          ServiceTag.create(name: st)
        end
        selected_tag = ServiceTag.find_by_name(st)
        ProgramServiceTag.create(org: org, program: prgm, service_tag: selected_tag)
      end

      p.each do |key,value|
        if ["ProgramDescription", "PopulationDescription", "ServiceAreaDescription" ].include? (key)
          value.each do |grabbed_field|
            GrabList.create(field_name: key , text: grabbed_field["Text"], xpath: grabbed_field["Xpath"],
                            page_url: grabbed_field["Domain"], org: org, program_id: prgm.id)
          end
        end
      end
    end
  end

  def extract_site_data(site, org)
    s = Site.new
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
    loc = Location.new
    loc.addr1 = site["Addr1"][0]["Text"] if site["Addr1"][0]["Text"]
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

  def create_poc(s,site,org)
    site["POCs"].each do |contact|
      poc = Poc.new
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

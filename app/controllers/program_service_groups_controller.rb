class ProgramServiceGroupsController < ApplicationController
  before_action :set_program_service_group, only: [:show, :edit, :update, :destroy]

  # GET /program_service_groups
  # GET /program_service_groups.json
  def index
    @program_service_groups = ProgramServiceGroup.all
  end

  # GET /program_service_groups/1
  # GET /program_service_groups/1.json
  def show
  end

  # GET /program_service_groups/new
  def new
    @program_service_group = ProgramServiceGroup.new
  end

  # GET /program_service_groups/1/edit
  def edit
  end

  # POST /program_service_groups
  # POST /program_service_groups.json
  def create
    @program_service_group = ProgramServiceGroup.new(program_service_group_params)

    respond_to do |format|
      if @program_service_group.save
        format.html { redirect_to @program_service_group, notice: 'Program service group was successfully created.' }
        format.json { render :show, status: :created, location: @program_service_group }
      else
        format.html { render :new }
        format.json { render json: @program_service_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /program_service_groups/1
  # PATCH/PUT /program_service_groups/1.json
  def update
    respond_to do |format|
      if @program_service_group.update(program_service_group_params)
        format.html { redirect_to @program_service_group, notice: 'Program service group was successfully updated.' }
        format.json { render :show, status: :ok, location: @program_service_group }
      else
        format.html { render :edit }
        format.json { render json: @program_service_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /program_service_groups/1
  # DELETE /program_service_groups/1.json
  def destroy
    @program_service_group.destroy
    respond_to do |format|
      format.html { redirect_to program_service_groups_url, notice: 'Program service group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program_service_group
      @program_service_group = ProgramServiceGroup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def program_service_group_params
      params.fetch(:program_service_group, {})
    end
end

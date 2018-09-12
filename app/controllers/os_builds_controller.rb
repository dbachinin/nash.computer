class OsBuildsController < ApplicationController
  before_action :set_os_build, only: [:show, :edit, :update, :destroy]

  # GET /os_builds
  # GET /os_builds.json
  def index
    @os_builds = OsBuild.all
  end

  # GET /os_builds/1
  # GET /os_builds/1.json
  def show
  end

  # GET /os_builds/new
  def new
    @os_build = OsBuild.new
    @options = OsOption.all
  end

  # GET /os_builds/1/edit
  def edit
    @options = OsOption.all
  end

  # POST /os_builds
  # POST /os_builds.json
  def create
    @os_build = OsBuild.new(os_build_params)

    respond_to do |format|
      if @os_build.save
        format.html { redirect_to @os_build, notice: 'Os build was successfully created.' }
        format.json { render :show, status: :created, location: @os_build }
      else
        format.html { render :new }
        format.json { render json: @os_build.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /os_builds/1
  # PATCH/PUT /os_builds/1.json
  def update
    respond_to do |format|
      if @os_build.update(os_build_params)
        format.html { redirect_to @os_build, notice: 'Os build was successfully updated.' }
        format.json { render :show, status: :ok, location: @os_build }
      else
        format.html { render :edit }
        format.json { render json: @os_build.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /os_builds/1
  # DELETE /os_builds/1.json
  def destroy
    @os_build.destroy
    respond_to do |format|
      format.html { redirect_to os_builds_url, notice: 'Os build was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_os_build
      @os_build = OsBuild.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def os_build_params
      params.require(:os_build).permit(:name, :price, :description, :sleep, :options => [])
    end
end

class OsOptionsController < ApplicationController
  before_action :set_os_option, only: [:show, :edit, :update, :destroy]

  # GET /os_options
  # GET /os_options.json
  def index
    @os_options = OsOption.all
  end

  # GET /os_options/1
  # GET /os_options/1.json
  def show
  end

  # GET /os_options/new
  def new
    @os_option = OsOption.new
  end

  # GET /os_options/1/edit
  def edit
  end

  # POST /os_options
  # POST /os_options.json
  def create
    @os_option = OsOption.new(os_option_params)

    respond_to do |format|
      if @os_option.save
        format.html { redirect_to @os_option, notice: 'Os option was successfully created.' }
        format.json { render :show, status: :created, location: @os_option }
      else
        format.html { render :new }
        format.json { render json: @os_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /os_options/1
  # PATCH/PUT /os_options/1.json
  def update
    respond_to do |format|
      if @os_option.update(os_option_params)
        format.html { redirect_to @os_option, notice: 'Os option was successfully updated.' }
        format.json { render :show, status: :ok, location: @os_option }
      else
        format.html { render :edit }
        format.json { render json: @os_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /os_options/1
  # DELETE /os_options/1.json
  def destroy
    @os_option.destroy
    respond_to do |format|
      format.html { redirect_to os_options_url, notice: 'Os option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_os_option
      @os_option = OsOption.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def os_option_params
      params.require(:os_option).permit(:name, :price, :description, :sleep)
    end
end

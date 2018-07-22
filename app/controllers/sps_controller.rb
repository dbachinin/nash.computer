class SpsController < ApplicationController
  before_action :set_sp, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :is_admin?
  # GET /sps
  # GET /sps.json
  def index
    @sps = Sp.all
  end
  def is_admin?
    unless current_user.is_admin
      redirect_to root_path, notice: 'Вы не имеете прав'
    else
      @user = current_user
    end
  end
  # GET /sps/1
  # GET /sps/1.json
  def show
  end

  # GET /sps/new
  def new
    @sp = Sp.new
  end

  # GET /sps/1/edit
  def edit
  end

  # POST /sps
  # POST /sps.json
  def create
    @sp = Sp.new(sp_params)

    respond_to do |format|
      if @sp.save
        format.html { redirect_to @sp, notice: 'Sp was successfully created.' }
        format.json { render :show, status: :created, location: @sp }
      else
        format.html { render :new }
        format.json { render json: @sp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sps/1
  # PATCH/PUT /sps/1.json
  def update
    respond_to do |format|
      if @sp.update(sp_params)
        format.html { redirect_to @sp, notice: 'Sp was successfully updated.' }
        format.json { render :show, status: :ok, location: @sp }
      else
        format.html { render :edit }
        format.json { render json: @sp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sps/1
  # DELETE /sps/1.json
  def destroy
    @sp.destroy
    respond_to do |format|
      format.html { redirect_to sps_url, notice: 'Sp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sp
      @sp = Sp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sp_params
      params.require(:sp).permit(:price, :name, :spec_act, :description)
    end
end

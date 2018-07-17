class TaryphsController < ApplicationController
  before_action :set_taryph, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :is_admin?
  # GET /taryphs
  # GET /taryphs.json
  def index
    @taryphs = Taryph.all
  end

  # GET /taryphs/1
  # GET /taryphs/1.json
  def show
  end
  def is_admin?
    unless current_user.is_admin
      redirect_to root_path, notice: 'Вы не имеете прав'
    else
      @user = current_user
    end
  end

  # GET /taryphs/new
  def new
    @taryph = Taryph.new
    @sps = Sp.all
  end

  # GET /taryphs/1/edit
  def edit
    @sps = Sp.all
  end

  # POST /taryphs
  # POST /taryphs.json
  def create
    @taryph = Taryph.new(taryph_params)
    @taryph.options = params[:taryph][:options].reject{|i|i.empty?}
    respond_to do |format|
      if @taryph.save
        format.html { redirect_to @taryph, notice: 'Taryph was successfully created.' }
        format.json { render :show, status: :created, location: @taryph }
      else
        format.html { render :new }
        format.json { render json: @taryph.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /taryphs/1
  # PATCH/PUT /taryphs/1.json
  def update
    @taryph.options = params[:taryph][:options].reject{|i|i.empty?}
    respond_to do |format|
      if @taryph.update(taryph_params)
        format.html { redirect_to @taryph, notice: 'Taryph was successfully updated.' }
        format.json { render :show, status: :ok, location: @taryph }
      else
        format.html { render :edit }
        format.json { render json: @taryph.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taryphs/1
  # DELETE /taryphs/1.json
  def destroy
    @taryph.destroy
    respond_to do |format|
      format.html { redirect_to taryphs_url, notice: 'Taryph was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_taryph
      @taryph = Taryph.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def taryph_params
      params.require(:taryph).permit(:sleep, :description, :price, :name, :period, :options => [])
    end
end

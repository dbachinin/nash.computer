class LicensesController < ApplicationController
  before_action :set_license, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include LicensesHelper

  # GET /licenses
  # GET /licenses.json
  def index
    @user = current_user
    if @user.is_admin
      @users = User.all
      # @licenses = @user.license
    elsif @user.licensed
      @users = User.where(id: current_user.id)
      else
        redirect_to licenses_stub_path
    end
  end
  def stub
    @user = current_user
    @licenses = @user.license
  end
  # GET /licenses/1
  # GET /licenses/1.json
  def show
    @user = current_user
    id = @license._id.to_s
    unless @user.is_admin
      redirect_to root_path, notice: 'Вы не имеете прав на просмотр этой страницы.' if @license.user_id != current_user.id
    end
    if @user.is_admin or @user.licensed
      if params[:lic] 
        file = "#{Rails.root}/tmp/license_#{id.reverse}.lic"
        File.open(file, 'wb' ){|f| f.write(@license.licensefile.data)}
          send_file(file, filename: "license.lic", type: "application/octet-stream")
      elsif params[:key]
        file = "#{Rails.root}/tmp/license_#{id.reverse}.key"
        %x( encode #{@license.key} #{file} )
          send_file("#{Rails.root}/tmp/license_#{id.reverse}.key", filename: "license.key", type: "application/octet-stream")
      end
    else
      @license = @user.license.find(params[:name]) if @user.license.where(name: params[:name]).exists?
      
      if params[:lic] 
        file = "#{Rails.root}/tmp/license_#{id.reverse}.lic"
        File.open(file, 'wb' ){|f| f.write(@license.licensefile.data)}
          send_file(file, filename: "license.lic", type: "application/octet-stream")
      elsif params[:key]
        file = "#{Rails.root}/tmp/license_#{id.reverse}.key"
        %x( encode #{@license.key} #{file} )
          send_file("#{Rails.root}/tmp/license_#{id.reverse}.key", filename: "license.key", type: "application/octet-stream")
      end
    end

  end

  # GET /licenses/new
  def new
    @user = current_user||=User.find(params[:user_id])
    @license = License.new
    # @key = create_license(@license._id.to_s)
  end

  # GET /licenses/1/edit
  def edit
    @user = current_user
    @user = User.find(params[:user_id]) if params[:user_id]
    @license = License.find_by(name: params[:name])
    unless @user.is_admin
        redirect_to root_path, notice: 'Вы не имеете прав на просмотр этой страницы.'
    end

  end

  # POST /licenses
  # POST /licenses.json
  def create
    @user = current_user||=User.find(params[:user_id])
    @license = @user.license.build(license_params)
    @license.user_id = params[:user_id]
    respond_to do |format|
      if @license.save
        @license.key = create_license(@license._id.to_s)
        unless @license.key
          redirect_to root_path, notice: 'Что-то пошло не так, попробуйте ещё раз.'
        end
        @license.save
        format.html { redirect_to license_path(@license.name), notice: 'Запись о лицензии создана.' }
        format.json { render :show, status: :created, location: license_path(@license.name) }
      else
        format.html { render :new }
        format.json { render json: @license.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /licenses/1
  # PATCH/PUT /licenses/1.json
  def update
    @user = current_user
    @user = params[:user_id] if params[:user_id]
    @license = License.find_by(name: params[:name])
    respond_to do |format|
      if @license.update(license_params)
        format.html { redirect_to license_path(@license.name), notice: 'Запись о лицензии обновлена.' }
        format.json { render :show, status: :ok, location: license_path(@license.name) }
      else
        format.html { render :edit }
        format.json { render json: @license.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /licenses/1
  # DELETE /licenses/1.json
  def destroy
    @license.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Запись о лицензии удалена.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_license
      License.where(name: params[:name]).exists? ? @license = License.find_by(name: params[:name]) : @license = License.find(params[:name])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def license_params
      params.permit(:name, :addres, :license_count, :license_restrict, :term_of_license, :description, :key)
    end
end

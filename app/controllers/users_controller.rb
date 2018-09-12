class UsersController < ApplicationController
  before_action :authenticate_user!, :check_admin
  # include LicensesHelper
  #respond_to :json
  respond_to :html, :js, :json

  include AvatarHelper
  def index
    if current_user.is_admin
      @users = User.all
      @user = current_user
    else
      @users = User.where(id: current_user.id)
    end
  end
  def check_admin
    return true if current_user.is_admin
  end

  def show
    if check_admin
      @user = User.find(params[:id])
    else
      @user = User.find(params[:id])
      unless params[:id] == current_user._id.to_s
        @user = User.find(current_user.id)
        flash[:error] = "Вы не имеете прав на просмотр этой страницы. \n Вы будете переаедены на начальную страницу."
      end
    end
  end
  
  def edit
  end
  n=0
  def change_pic
    id = params[:id]
    user = User.find(id)
    create_avatar(user.id)
    file = "tmp/#{user.id}.png"
    user.pic = BSON::Binary.new(File.read(file))
    user.update
    FileUtils.rm(file) if File.exist?(file)
    respond_with do |format|
      format.json
    end
  end

  def update
   current_user.is_admin ? @user = User.find(params[:id]) : @user = User.find(current_user.id)
   # @user.avatar = create_avatar(@user.id)
   respond_to do |format|
    if @user.update(user_params)
      format.html { redirect_to  users_path, notice: "#{@user.name} успешно обновлён." }
    else
      format.html { render :edit }
    end
  end
end

def create_pre_order_ajax
  @user = current_user
  @order = @user.order.build
  @order.taryph_id = params[:taryph_id] if params[:taryph_id]
  @order.sp_ids = params[:sps] if params[:sps]
  lic = @order.build_license
  lic.license_count = 1
  lic.name = @user.id.to_s + @order.id.to_s + @order.sp_ids.join||'' + @order.taryph_id||''
  respond_to do |format|
    if @order.save and lic.save
      format.js
    else
      redirect_to root_path, notice: 'Что-то пошло не так, попробуйте ещё раз.'
    end
  end
end

# def create_pre_order
#   @order = current_user.order.build
#   @order.taryph_id = params[:taryph_id] if params[:taryph_id]
#   @order.sp_ids = params[:sp_ids] if params[:sp_ids]
#   lic = @order.build_license
#   lic.license_count = 1
#   lic.name = current_user.id.to_s + @order.id.to_s + @order.taryph_id
#   unless @order.save and lic.save
#     redirect_to root_path, notice: 'Что-то пошло не так, попробуйте ещё раз.'
#   end
# end

  def destroy
    @user = User.find(params[:id])
    if current_user.id == @user.id or check_admin
      @user.destroy
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'User was successfully destroyed.' }
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:pic, :name, :email, :is_admin, :password, :password_confirmation, :licensed)
  end

end

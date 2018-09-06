class HomesController < ApplicationController
  # before_action :set_home, only: [:show, :edit, :update, :destroy]
  
  # GET /homes
  # GET /homes.json
  def index
    @sps = Sp.all
    @taryphs = Taryph.any_of({sleep: false},{sleep: "0"}).all
    @user = current_user if current_user
    @sps = Sp.all
    if @user != nil
    	@admin = true if @user.is_admin
    end  
  end

end

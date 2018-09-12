class HomesController < ApplicationController
  # before_action :set_home, only: [:show, :edit, :update, :destroy]
  
  # GET /homes
  # GET /homes.json
  def index
    @sps = Sp.all
    @taryphs = Taryph.any_of({sleep: false},{sleep: "0"}).all
    @user = current_user if current_user
    @os_builds = OsBuild.all
    @os_options = OsOption.all
    # @sps = Taryph.all.map { |e| {value: e.id.to_s, label: e.name} }
    if @user != nil
    	@admin = true if @user.is_admin
    end
    if params[:id]
      @license = License.find(params[:id])
      if @admin or @user.licensed
        if params[:lic] 
            send_data @license.licensefile.data, filename: "license.lic", type: "application/octet-stream"
        elsif params[:key]
          file = "#{Rails.root}/tmp/license_#{id.reverse}.key"
          %x( encode #{@license.key} #{file} )
          key = File.read(file)
          File.delete(file)
          send_data key, filename: "license.key", type: "application/octet-stream"
        end
      else
        # @license = @user.order.select{|ord|ord.license.find(params[:name])} if @user.order.select{|ord|ord.license.where(name: params[:name]).exists?}
        @license = License.find(params[:id])
        if params[:lic] 
            send_data @license.licensefile.data, filename: "license.lic", type: "application/octet-stream"
        elsif params[:key]
          file = "#{Rails.root}/tmp/license_#{id.reverse}.key"
          %x( encode #{@license.key} #{file} )
          key = File.read(file)
          File.delete(file)
          send_data key, filename: "license.key", type: "application/octet-stream"
        end
      end 
    end
  end

end

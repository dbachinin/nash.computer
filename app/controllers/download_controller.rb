class DownloadController < ApplicationController
	include DownloadHelper
  def download
  	token = check_token(params[:token])
  	p params[:token]
  	cc = params[:cc]
  	p cc
  	desk = params[:description]
  	p desk
  	id = token.split[0] if token
  	uuid = token.split[1] if token
  	if id
  		lic = License.find(id)
  		count = 1
  		if lic.licenses.count <= lic.license_count
  			if lic.licenses.select{|i|i.include?(uuid)}.empty? and lic.licenses.count <= lic.license_count and params[:lic]
	  			lic.licenses << [uuid, cc, request.remote_addr, count, desk]
	  			lic.save
	  		elsif params[:lic] and !lic.licenses.select{|i|i.include?(uuid)}.empty? and lic.licenses.count <= lic.license_count
	  			lic.licenses = lic.licenses.map{|v|v[3]+=1 if v.include?(uuid);v }
	  			lic.save
	  		end
	  		if params[:lic] 
		  		file = "#{Rails.root}/tmp/license_#{id.reverse}.lic"
		  		File.open(file, 'wb' ){|f| f.write(lic.licensefile.data)}
		        send_file(file, filename: "license.lic", type: "application/octet-stream")
		    elsif params[:key]
		  		file = "#{Rails.root}/tmp/license_#{id.reverse}.key"
		  		%x( encode #{lic.key} #{file} )
		        send_file("#{Rails.root}/tmp/license_#{id.reverse}.key", filename: "license.key", type: "application/octet-stream")
		    end
	    end
    end
  end
end

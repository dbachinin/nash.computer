class BaseController < ApplicationController
	# before_filter :find_model
	respond_to :html, :json

	

	# private
	# def find_model
	# 	@model = Model.find(params[:id]) if params[:id]
	# end
end
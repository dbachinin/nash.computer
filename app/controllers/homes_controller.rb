class HomesController < ApplicationController
  # before_action :set_home, only: [:show, :edit, :update, :destroy]
  
  # GET /homes
  # GET /homes.json
  def index
    @sps = Sp.all
  end

end
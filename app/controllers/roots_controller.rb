class RootsController < ApplicationController
  def index
    redirect_to distributor_root_path(Distributor.default)
  end
end

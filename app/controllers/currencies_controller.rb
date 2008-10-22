class CurrenciesController < ApplicationController
  def create
    self.current_currency = params[:currency]
    redirect_to(:back) rescue redirect_to(root_path)
  end
end

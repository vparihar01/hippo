class HomesController < ApplicationController
  skip_before_filter :authorize!
  def index
  	redirect_to  cloud_providers_path if current_user.present?
  end

end

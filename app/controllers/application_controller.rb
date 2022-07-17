class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search_keyword

  def after_sign_in_path_for(resource)
    public_tracks_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def set_search_keyword
    @search_keyword = Track.new
  end
end

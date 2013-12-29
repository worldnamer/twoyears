class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false)
    if request.referer == sign_in_url
      super
    else
      stored_location = stored_location_for(resource)
      if stored_location
        '#/' + stored_location
      else
        request.referer || root_path
      end
    end
  end
end

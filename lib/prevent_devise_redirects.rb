require 'application_helper'

class PreventDeviseRedirects < Devise::FailureApp
  include ApplicationHelper

  def respond
    if http_auth?
      http_auth
    elsif warden_options[:recall]
      custom_redirect
    else
      redirect
    end
  end

  def custom_redirect
    store_location!
    if flash[:timedout] && flash[:alert]
      flash.keep(:timedout)
      flash.keep(:alert)
    else
      flash[:alert] = i18n_message
    end

    custom_redirect_url = angularize(redirect_url)
    redirect_to custom_redirect_url
  end
end
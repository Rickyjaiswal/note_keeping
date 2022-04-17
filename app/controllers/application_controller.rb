class ApplicationController < ActionController::Base
	before_action :verify_parameter, if: :devise_controller?

    protected

    def verify_parameter
        devise_parameter_sanitizer.permit(:sign_up,keys:[:name,:email,:password,:password_confirmation])
    end

end

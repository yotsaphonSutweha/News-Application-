class RegistrationsController < Devise::RegistrationsController
    protected 
    def after_sign_up_path_for(resource)
        new_user_profile_path(resource)
    end
end
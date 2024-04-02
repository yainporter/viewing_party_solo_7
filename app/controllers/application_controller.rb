class ApplicationController < ActionController::Base
   helper_method :current_user #This allows current_user to be accessible in our Views

   def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
   end

   private

   def error_message(errors)
      errors.full_messages.join(', ')
   end
end

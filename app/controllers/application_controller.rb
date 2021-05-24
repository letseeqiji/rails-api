class ApplicationController < ActionController::API
  include Authuser
  include Paginable
  # before_action :check_login?

  # private
  #   def is_admin?
  #     current_user&.role == 0
  #   end

    # def check_login?
    #   head 401 unless current_user
    # end
end

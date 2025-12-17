class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def require_admin
    return if current_user&.admin?
    redirect_to root_path, alert: "You must be an admin to access this section."
  end

  helper_method :current_user

  private

    def current_user
      Current.session&.user
    end

    # Only allows freelancers to execute certain actions
    def require_freelancer
      return if current_user&.freelancer?
      redirect_back(
        fallback_location: projects_path,
        alert: "Only freelancers can perform this action."
      )
    end
end

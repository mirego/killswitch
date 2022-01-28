module DeviseHelper
  # Overwrite Devise error messages helper
  def devise_error_messages!
    return unless resource.errors.any?

    render partial: 'shared/error_messages', locals: { record: resource }
  end
end

module RecaptchaVerifiable
  extend ActiveSupport::Concern

  private

  def check_recaptcha
    unless verify_recaptcha
      flash[:recaptcha_error] = "reCAPTCHA verification failed, please try again."
      # Adjust params method as needed for each controller
      self.resource = resource_class.new(resource_params)
      respond_with_navigational(resource) { render :new }
    end
  end

  # You may want to define a generic resource_params and override in each controller if needed
  def resource_params
    if params[resource_name].present?
      params.require(resource_name).permit!
    else
      {}
    end
  end
end

module RecaptchaVerifiable
  extend ActiveSupport::Concern

  private

  def check_recaptcha
    unless verify_recaptcha
      flash[:recaptcha_error] = "reCAPTCHA verification failed, please try again."
      self.resource = resource_class.new(resource_params)
      respond_with_navigational(resource) { render :new }
    end
  end

  # Placeholder for resource_params, to be overridden in controllers
  def resource_params
    raise NotImplementedError, "You must define `resource_params` in the controller."
  end
end

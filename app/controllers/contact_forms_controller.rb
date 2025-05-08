class ContactFormsController < ApplicationController
  before_action :load_page, only: [ :new, :create ]

  def new
    @contact = ContactForm.new
  end

  def create
    begin
      @contact = ContactForm.new(contact_params)
      @contact.request = request
      # Verify reCAPTCHA before attempting to deliver
      if verify_recaptcha(model: @contact) && @contact.deliver
        flash[:notice] = "Thank you for your message!"
        redirect_to new_contact_form_path
      else
        # If reCAPTCHA or form validation fails, re-render the form
        flash.now[:error] = "There was an error with your submission. Please check the form and try again."
        render :new
      end
    rescue ScriptError
      flash[:error] = "Sorry, this message appears to be spam and was not delivered."
      render :new
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def contact_params
      params.require(:contact_form).permit(:name, :email, :file, :message, :nickname)
    end

    def load_page
      @page = Page.find_by_name(:contact)
    end
end

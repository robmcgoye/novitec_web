class ContactForm < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :file, attachment: true
  attribute :message, validate: true
  attribute :nickname, captcha: true

  def headers
    {
      # this is the subject for the email generated, it can be anything you want
      subject: "Novi Contact Form",
      to:  Rails.application.credentials.dig(:smtp, :contact_form_email_to),
      from: %("#{name}" <#{email}>)
      # the from will display the name entered by the user followed by the email
    }
  end
end

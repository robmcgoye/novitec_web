require "digest/sha2"
class DeviseMailer < Devise::Mailer
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@#{Rails.application.credentials.dig(:smtp, :message_id_domain)}"
end

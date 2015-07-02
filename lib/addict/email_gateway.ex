defmodule Addict.EmailGateway do
  @moduledoc """
  The Addict EmailGateway is a wrapper for sending e-mails with the preferred
  mail library. For now, only Mailgun is supported.
  """
  def send_welcome_email(user, mailer \\ Addict.Mailers.Mailgun) do
    mailer.send_email_to_user "<#{user.email}>",
                       Application.get_env(:addict, :register_from_email),
                       Application.get_env(:addict, :register_subject),
                       Application.get_env(:addict, :email_templates).register_template(user)
  end

  def send_password_recovery_email(user, mailer \\ Addict.Mailers.Mailgun) do
    mailer.send_email_to_user "<#{user.email}>",
                       Application.get_env(:addict, :password_recover_from_email),
                       Application.get_env(:addict, :password_recover_subject),
                       Application.get_env(:addict, :email_templates).password_recovery_template(user)
  end
end

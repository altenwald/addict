defmodule Addict.EmailGateway do
  @moduledoc """
  The Addict EmailGateway is a wrapper for sending e-mails with the preferred
  mail library. For now, only Mailgun is supported.
  """
  def send_welcome_email(user, mailer \\ Addict.Mailers.Mailgun) do
    case Application.get_env(:addict, :mode) do
      :mailgun ->
        send_welcome_email_mailgun(user, mailer) 
      _smtp ->
        send_welcome_email_smtp(user)
    end
  end

  def send_welcome_email_mailgun(user, mailer \\ Addict.Mailers.Mailgun) do
    mailer.send_email_to_user "<#{user.email}>",
                       Application.get_env(:addict, :register_from_email),
                       Application.get_env(:addict, :register_subject),
                       Application.get_env(:addict, :email_templates).register_template(user)
  end

  def send_welcome_email_smtp(user) do
    subject = Application.get_env(:addict, :register_subject)
    body = Application.get_env(:addict, :email_templates).register_template(user)
    relay = Application.get_env(:addict, :smtp_server)
    from = Application.get_env(:addict, :register_from_email)
    smtp_username = Application.get_env(:addict, :smtp_username)
    smtp_password = Application.get_env(:addict, :smtp_password)
    smtp_port = Application.get_env(:addict, :smtp_port)
    smtp_ssl = Application.get_env(:addict, :smtp_ssl)

    :gen_smtp_client.send({"#{user.email}", ["#{user.email}"], 
            "Subject: #{subject}\r\nFrom: #{from}\r\nTo: #{user.email}\r\n\r\n#{body}"}, 
            [{:relay, relay}, {:username, smtp_username}, {:password, smtp_password}, {:port, smtp_port}, {:ssl, smtp_ssl}])
  end

  def send_password_recovery_email(user, mailer \\ Addict.Mailers.Mailgun) do
    case Application.get_env(:addict, :mode) do
      :mailgun ->
        send_password_recovery_email_mailgun(user, mailer) 
      _smtp ->
        send_password_recovery_email_smtp(user)
    end
  end
  def send_password_recovery_email_mailgun(user, mailer \\ Addict.Mailers.Mailgun) do
    mailer.send_email_to_user "<#{user.email}>",
                       Application.get_env(:addict, :password_recover_from_email),
                       Application.get_env(:addict, :password_recover_subject),
                       Application.get_env(:addict, :email_templates).password_recovery_template(user)
  end

  def send_password_recovery_email_smtp(user) do
    subject = Application.get_env(:addict, :password_recover_subject)
    body = Application.get_env(:addict, :email_templates).password_recovery_template(user)
    from = Application.get_env(:addict, :password_recover_from_email)
    relay = Application.get_env(:addict, :smtp_server)
    smtp_username = Application.get_env(:addict, :smtp_username)
    smtp_password = Application.get_env(:addict, :smtp_password)
    smtp_port = Application.get_env(:addict, :smtp_port)
    smtp_ssl = Application.get_env(:addict, :smtp_ssl)

    :gen_smtp_client.send({"#{user.email}", ["#{user.email}"], 
            "Subject: #{subject}\r\nFrom: #{from}\r\nTo: #{user.email}\r\n\r\n#{body}"}, 
            [{:relay, relay}, {:username, smtp_username}, {:password, smtp_password}, {:port, smtp_port}, {:ssl, smtp_ssl}])
  end
end

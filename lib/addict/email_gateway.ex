defmodule Addict.EmailGateway do
  @moduledoc """
  The Addict EmailGateway is a wrapper for sending e-mails with the preferred
  mail library. For now, only Mailgun is supported.
  """
  def send_welcome_email(user, mailer \\ Addict.Mailers.Mailgun) do
    mailer.send_email_to_user "#{user.username} <#{user.email}>",
                       Application.get_env(:addict, :register_from_email),
                       Application.get_env(:addict, :register_subject),
                       Application.get_env(:addict, :email_templates).register_template(user)
  end

  def send_password_recovery_email(user, mailer \\ Addict.Mailers.Mailgun) do
    mailer.send_email_to_user "#{user.username} <#{user.email}>",
                       Application.get_env(:addict, :password_recover_from_email),
                       Application.get_env(:addict, :password_recover_subject),
                       Application.get_env(:addict, :email_templates).password_recovery_template(user)
  end

  def send_email(user, mailer \\ Addict.Mailers.Mailgun) do
    body = Application.get_env(:addict, :email_templates).register_template(user)
    :gen_smtp_client.send({"#{Application.get_env(:addict, :register_from_email)}", ["#{Application.get_env(:addict, :register_from_email)}"], "Subject: #{Application.get_env(:addict, :register_subject)}}\r\nFrom: #{Application.get_env(:addict, :register_from_email)}\r\nTo: #{user.email}\r\n\r\n#{body}"}, [{:relay, Application.get_env(:addict, :smtp_server)}, {:username, Application.get_env(:addict, :smtp_username)}, {:password, Application.get_env(:addict, :smtp_password)},{:port, 465},{:ssl, true}])
    IO.puts "#{user.username}"
    {:ok, "#{user.username}"}
  end
end

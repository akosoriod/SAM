module ParamsHelper
  def self.inbox_params(params, username)
    inbox = {
      body: {
        :Sender => username,
        :Recipient => params[:recipient],
        :Cc => params[:cc],
        :Distribution_list => params[:distribution_list],
        :Subject => params[:subject],
        :Message_body => params[:message_body],
        :Attachments => params[:attachment],
        :Sent_dateTime => params[:sent_dateTime],
        :Urgent => params[:urgent],
        :Read => false
      }.to_json,
      :headers => {
        'Content-Type' => 'application/json'
      }
    }
    return inbox
  end

  def self.send_mail_params(params, username)
    mail = {
      body: {
        :sender => username,
        :recipient => params[:recipient],
        :distribution_list => params[:distribution_list],
        :subject => params[:subject],
        :message_body => params[:message_body],
        :attachment => params[:attachment],
        :cc => params[:cc],
        :sent_dateTime => params[:sent_dateTime],
        :draft => params[:draft],
        :urgent => params[:urgent],
        :confirmation => params[:confirmation]
      }.to_json,
      :headers => {
        'Content-Type' => 'application/json'
      }
    }
    return mail
  end
end

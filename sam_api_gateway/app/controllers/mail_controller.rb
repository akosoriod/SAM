class MailController < ApplicationController

  skip_before_action :validate_token, only: :send_drafts

  # POST /sent_mails  - sendMail
  def sendMail
    @sentMail = HTTParty.post(ms_ip("sm")+"/sent_mails",ParamsHelper.send_mail_params(params, @username))
    if @sentMail.code == 201
      render status: 201, json: @sentMail

      #TO_DO Si el mensaje se envía (NO ES BORRADOR) se guarda en la base de inbox de usuario que recibe
      unless params[:draft]
        @receivedMail = HTTParty.post(ms_ip("in")+"/received_mails", ParamsHelper.inbox_params(params, @username))

        @sendnotification = HTTParty.post(ms_ip("nt")+"/notifications", { body: {
          :username => params[:recipient],
          :sender => @username
          }.to_json,:headers => {
            'Content-Type' => 'application/json'
          }})
      end

      # TO_DO Si el mensaje se le pone una fecha de envío se programa su envío
      # Si no se pone fecha de envío se envía de una vez y no es borrador
      if params[:sent_dateTime] != DateTime.now and params[:sent_dateTime] != ""
        idMensaje = JSON.parse(@sentMail.body)["id"]
        @scheduledMail = HTTParty.post(ms_ip("schs")+"/scheduledsending/add", {
         body: {
           :user_id => @username,
           :mail_id => idMensaje,
           :date => params[:sent_dateTime]
         }.to_json,
         :headers => {
           'Content-Type' => 'application/json'
         }
       })
      end

    else
      render json: {messsage: "Error, mail couldn't be sent or saved"}
    end
  end

# PUT /drafts/1  - send_daft
  def send_drafts
  draft={draft:false}.to_json
    @sent_draft = HTTParty.put(ms_ip("sm")+"/sentdraft/"+params[:id].to_s,:body=>draft)
    if @sent_draft.code == 200
      mail_draft=JSON.parse(@sent_draft.body)
      mail2 = {
          body: {
          :Sender => mail_draft['sender'],
          :Recipient => mail_draft['recipient'],
          :Cc => mail_draft['cc'],
          :Distribution_list => mail_draft['distribution_list'],
          :Subject => mail_draft['subject'],
          :Message_body => mail_draft['message_body'],
          :Attachments => mail_draft['attachment'],
          :Sent_dateTime => mail_draft['sent_dateTime'],
          :Urgent => mail_draft['urgent'],
          :Read => false
          }.to_json,
          :headers => {
          'Content-Type' => 'application/json'
          }
          }
      receivedMail = HTTParty.post(ms_ip("in")+"/received_mails", mail2)
      render status: 200, json: @sent_draft.body
    else
      render status: 404, json: {body:{message: "Draft wasn't modify"}}.to_json
    end
  end

  # GET /sent_mails - sentMails
  def sentMails
    @sentMails = getAllSentMails
    if @sentMails.code == 200
      render status: 200, json: @sentMails.body
    else
      render status: 404, json: {body:{message: "Sent Mails not found"}}.to_json
    end
  end

  # GET /sent_mails/1   - sentMails/1
  def sentMail
    @sentMail = checkSentMail(params[:id])
    if @sentMail.code == 200
      render status: 200, json: @sentMail.body
    else
      render status: 404, json: {body:{message: "Sent Mail not found"}}.to_json
    end
  end

  # GET /sent_mails/drafts - drafts
  def drafts
    if params[:id] != nil
      @sentMails = HTTParty.get(ms_ip("sm")+"/drafts/"+params[:id].to_s)
    else
      @sentMails = HTTParty.get(ms_ip("sm")+"/drafts")
    end
    if @sentMails.code == 200
      render status: 200, json: @sentMails.body
    else
      render status: 404, json: {body:{message: "Drafts not found"}}.to_json
    end
  end

  # GET /sent_mails/urgents - senturgent
  def urgent
    if params[:id] != nil
      @sentMails = HTTParty.get(ms_ip("sm")+"/senturgent/"+params[:id].to_s)
    else
      @sentMails = HTTParty.get(ms_ip("sm")+"/senturgent")
    end
    if @sentMails.code == 200
      render status: 200, json: @sentMails.body
    else
      render status: 404, json: {body:{message: "Sent Mails not found"}}.to_json
    end
  end

  # GET /sent_mails/draftAndUrgent - draftsurgent
  def draftAndUrgent
    if params[:id] != nil
      @sentMails = HTTParty.get(ms_ip("sm")+"/draftsurgent/"+params[:id].to_s)
    else
      @sentMails = HTTParty.get(ms_ip("sm")+"/draftsurgent")
    end
    if @sentMails.code == 200
      render status: 200, json: @sentMails.body
    else
      render status: 404, json: {body:{message: "Urgent drafts not found"}}.to_json
    end
  end

#PUT
  def modifyDraft
    data={
        recipient: params[:recipient],
        cc: params[:cc],
        distribution_list: params[:distribution_list],
        subject: params[:subject],
        message_body: params[:message_body],
        attachment: params[:attachment],
        sent_dateTime: params[:sent_dateTime],
        urgent: params[:urgent],
        draft: params[:draft],
        confirmation: params[:confirmation]
    }
    @modifyDraft = HTTParty.put(ms_ip("sm")+"/drafts/"+params[:id].to_s,:body=>data.to_json,
     :headers => { "Content-Type" => 'application/json'})
    if @modifyDraft.code == 200
      render status: 200, json: @modifyDraft.body
    else
      render status: 404, json: {body:{message: "Draft wasn't modify"}}.to_json
    end
  end

# DELETE
  def delSent
    @resp = HTTParty.delete(ms_ip("sm")+"/sent_mails/"+params[:id].to_s)
    if @resp.code == 200
      render status: 200, json: {body:{message: "Sent mail deleted"}}.to_json
    else
      render status: 404, json: {body:{message: "Sent mail couldn't be deleted"}}.to_json
    end
  end

#DELETE
  def delDraft
    @resp = HTTParty.delete(ms_ip("sm")+"/drafts/"+params[:id].to_s)
    if @resp.code == 200
      render status: 200, json: {body:{message: "Draft deleted"}}.to_json
    else
      render status: 404, json: {body:{message: "Draft couldn't be deleted"}}.to_json
    end
  end


  def getAllSentMails
    results = HTTParty.get(ms_ip("sm")+"/sent_mails/user/"+@username)
    return results
  end

  def checkSentMail(id)
    results = HTTParty.get(ms_ip("sm")+"/sent_mails/"+id.to_s)
    return results
  end

##############################################################################

  def delReceivedMail
    @result = HTTParty.delete(ms_ip("in")+"received_mails"+params[:id].to_s)
    if @result.code == 200
      render status: 200, json: {body:{message: "Mail deleted"}}.to_json
    else
      render status: 404, json: {body:{message: "Mail couldn't be deleted"}}.to_json
    end
  end

  def received_mails
    @result = HTTParty.get(ms_ip("in")+"/inbox/user/"+@username)
    if @result.code == 200
      render status: 200, json: @result.body
    else
      render status: 404, json: {body:{message: "Reeceived Mails not found"}}.to_json
    end
  end

  def received_mail
    @result = HTTParty.get(ms_ip("in")+"/received_mails"+params[:id].to_s)
    if @result.code == 200
      render status: 200, json: @result.body
    else
      render status: 404, json: {body:{message: "Mail not found"}}.to_json
    end
  end

  def bySender
    @result = HTTParty.get(ms_ip("in")+"/inbox/#{@username}/sender/"+params[:sender])
    if @result.code == 200
      render status: 200, json: @result.body
    else
      render status: 404, json: {body:{message: "Not mails from "+params[:sender]+" found"}}.to_json
    end
  end

  def by_filter
    params
      result = HTTParty.get("#{ms_ip("in")}/inbox/#{@username}/#{params[:filter]}")
      if result.code == 200
        render status: 200, json: result.body
      else
        render status: 404, json: {body:{message: "Not #{params[:filter]} mails found"}}.to_json
      end
  end

end

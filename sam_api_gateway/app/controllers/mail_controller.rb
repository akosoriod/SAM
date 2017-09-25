class MailController < ApplicationController

  # POST /sent_mails  - sendMail
  def sendMail
      puts @username
    mail = {
      body: {
        :sender => @username,
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

    mail2 = {
      body: {
        :Sender => @username,
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



    @sentMail = HTTParty.post(ms_ip("sm")+"/sent_mails",mail)
    if @sentMail.code == 201
      render status: 201, json: @sentMail

      #TO_DO Si el mensaje se envía (NO ES BORRADOR) se guarda en la base de inbox de usuario que recibe
      unless params[:draft]
        @receivedMail = HTTParty.post(ms_ip("in")+"/received_mails", mail2)

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
        @idMensaje = JSON.parse(@sentMail.body)["id"]
       @scheduledMail = HTTParty.post(ms_ip("schs")+"/scheduledsending/add", {
         body: {
           :user_id => @username,
           :mail_id => @idMensaje,
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
    results = HTTParty.get(ms_ip("sm")+"/sent_mails")
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
    @result = get_received_mails
    if @result.code == 200
      render status: 200, json: @result.body
    else
      render status: 404, json: {body:{message: "Reeceived Mails not found"}}.to_json
    end
  end

  def received_mail
    @result = get_received_mail(params[:id])
    if @result.code == 200
      render status: 200, json: @result.body
    else
      render status: 404, json: {body:{message: "Mail not found"}}.to_json
    end
  end

  def bySender
    @result = HTTParty.get(ms_ip("in")+"/inbox/"+@username+"/sender/"+params[:sender])
    if @result.code == 200
      render status: 200, json: @result.body
    else
      render status: 404, json: {body:{message: "Not mails from "+params[:sender]+" found"}}.to_json
    end
  end

  def read
    @result = HTTParty.get(ms_ip("in")+"/inbox/"+@username+"/read")
    if @result.code == 200
      render status: 200, json: @result.body
    else
      render status: 404, json: {body:{message: "Not read mails found"}}.to_json
    end
  end

  def unread
    @result = HTTParty.get(ms_ip("in")+"/inbox/"+@username+"/unread/")
    if @result.code == 200
      render status: 200, json: @result.body
    else
      render status: 404, json: {body:{message: "Not unread mails found"}}.to_json
    end
  end

  def urgent
    @result = HTTParty.get(ms_ip("in")+"/inbox/"+@username+"/urgent/")
    if @result.code == 200
      render status: 200, json: @result.body
    else
      render status: 404, json: {body:{message: "Not urgent mails found"}}.to_json
    end
  end

  def not_urgent
    @result = HTTParty.get(ms_ip("in")+"/inbox/"+@username+"/not_urgent/")
    render status: 200, json: @result.body
  end

  def get_received_mails
    @response = HTTParty.get(ms_ip("in")+"/inbox/user/"+@username)
    #render json: @response.body
    return @response
  end

  def get_received_mail(id)
    @response = HTTParty.get(ms_ip("in")+"/received_mails"+id.to_s)
    return @response
  end

end

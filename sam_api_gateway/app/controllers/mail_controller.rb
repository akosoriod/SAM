class MailController < ApplicationController

  # POST /sent_mails
  def sendMail
    mail = {
      :body =>{
        sender: parms[:sender],
        recipient: params[:recipient],
        distribution_list: params[:distribution_list],
        subject: params[:subject],
        message_body: params[:message_body],
        attachment: params[:attachment],
        cc: params[:cc],
        sent_dateTime: params[:sent_dateTime],
        daft: params[:daft],
        urgent: params[:urgent],
        confirmation: params[:confirmation]
      }.to_json,
      :headers =>{
        'Content-Type' => 'application/json'
      }
    }
    sentMail = Httparty.post(ms_ip("sm")+"/sent_mails",mail)
    if sentMail.code == 200
        render status: 200, json: {body:{message: "Mail Sent"}}.to_json
      else
        render status: 404, json: {body:{message: "Error can't send mail"}.to_json
      end
  end

# GET /sent_mails
  def sentMails
    @sentMails = getAllSentMails
    if !params[:daft].nil || !params[:urgent].nil
      @sentMails = getFilteredMails(params[:daft],params[:urgent])
    end
    if sentMails.code == 200
      render status: 200, json: @sentMails
    else
      render status: 404, json: {body:{message: "Sent Mails not found"}.to_json
    end
  end

  # GET /sent_mails/1
  def sentMail
    @sentMail=checkSentMail(id)
    if sentMail.code == 200
      render status: 200, json: @sentMail
    else
      render status: 404, json: {body:{message: "Sent Mail not found"}.to_json
    end
  end

  private

    def getAllSentMails
      results = Httparty.get(ms_ip("sm")+"/sent_mails")
      return results
    end

    def checkSentMail(id)
      results = Httparty.get(ms_ip("sm")+"/sent_mails/"+id.to_s)
      return results
    end

    def getFilteredMails(daft,urgent)
      results = Httparty.get(ms_ip("sm")+"/sent_mails"+query:{query:daft,query:urgent})
      return results
    end

  end

end

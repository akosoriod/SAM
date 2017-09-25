class SentMailsController < ApplicationController
  before_action :set_sent_mail, only: [:show, :update, :destroy]

  # GET /sent_mails
  def index
    @sent_mails = SentMail.sent
    render json: @sent_mails.to_json(:only => [ :id, :subject, :sent_dateTime, :draft, :urgent, :confirmation, :created_at ])
  end

  # GET /sent_mails/1
  def show
    render json: SentMail.sentId(params[:id])
    if SentMail.sentId(params[:id]).length == 0
      render status: 404
    end
  end

  # POST /sent_mails
  def create
    @sent_mail = SentMail.new(sent_mail_params)
    if @sent_mail.subject = ""
      @sent_mail.subject = "(sin asunto)"
    end
    if @sent_mail.sent_dateTime = ""
      @sent_mail.sent_dateTime = DateTime.now
    end
    if @sent_mail.save
      render json: @sent_mail, status: :created, location: @sent_mail
    else
      render json: @sent_mail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sent_mails/1
  def update
    if @sent_mail.update(sent_mail_params)
      render json: @sent_mail
    else
      render json: @sent_mail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /drafts/1
  def modifyDraft
    @update_mail=SentMail.drafts.find(params[:id])
    if @update_mail.update_attributes(recipient: params[:recipient],
      cc: params[:cc],
      distribution_list: params[:distribution_list],
      subject: params[:subject],
      message_body: params[:message_body],
      attachment: params[:attachment],
      sent_dateTime: params[:sent_dateTime],
      urgent: params[:urgent],
      draft: params[:draft],
      confirmation: params[:confirmation])

      render json: @update_mail
    else
      render json: @update_mail.errors, status: :unprocessable_entity
    end
  end


  # DELETE /sent_mails/1
  def destroy
    SentMail.sent.find(params[:id]).destroy
    render status: 200
  end

  # DELETE /drafts/1
  def delDraft
    SentMail.drafts.find(params[:id]).destroy
    render status: 200
  end

  #drafts
  def drafts
    if params[:id] != nil
      @draft = SentMail.draftsId(params[:id])
      if SentMail.draftsId(params[:id]).length == 0
        render status: 404
      else
        render json: @draft
      end
    else
      @sent_mails = SentMail.drafts
      render json: @sent_mails.to_json(:only => [ :id, :subject, :sent_dateTime, :draft, :urgent, :confirmation, :created_at ])
    end

  end

  #urgents
  def urgent
    if params[:id] != nil
      @urgent = SentMail.urgentId(params[:id])
      if SentMail.urgentId(params[:id]).length == 0
        render status: 404
      else
        render json: @urgent
      end
    else
      @sent_mails = SentMail.urgent
      render json: @sent_mails.to_json(:only => [ :id, :subject, :sent_dateTime, :draft, :urgent, :confirmation, :created_at ])
    end

  end

  #drafts and urgents
  def draftAndUrgent
    if params[:id] != nil
      @draftUrgent = SentMail.draftAndUrgentId(params[:id])
      if SentMail.draftAndUrgentId(params[:id]).length == 0
        render status: 404
      else
        render json: @draftUrgent
      end
    else
      @sent_mails = SentMail.draftAndUrgent
      render json: @sent_mails.to_json(:only => [ :id, :subject, :sent_dateTime, :draft, :urgent, :confirmation, :created_at ])
    end

  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sent_mail
    @sent_mail = SentMail.sentId(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def sent_mail_params
    params.require(:sent_mail).permit(:sender, :recipient, :cc, :distribution_list, :subject, :message_body, :attachment, :sent_dateTime, :draft, :urgent, :confirmation)
  end
end

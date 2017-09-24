class SentMailsController < ApplicationController
  before_action :set_sent_mail, only: [:show, :update, :destroy]

  # GET /sent_mails
  def index
    @sent_mails = SentMail.sent
    render json: @sent_mails.to_json(:only => [ :id, :subject, :sent_dateTime, :daft, :urgent, :confirmation, :created_at ])
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

  # DELETE /sent_mails/1
  def destroy
    SentMail.sent.find(params[:id]).destroy
    render status: 200
  end

  # DELETE /dafts/1
  def delDaft
    SentMail.dafts.find(params[:id]).destroy
    render status: 200
  end

  #dafts
  def dafts
    if params[:id] != nil
      @daft = SentMail.daftsId(params[:id])
      if SentMail.daftsId(params[:id]).length == 0
        render status: 404
      else
        render json: @daft
      end
    else
      @sent_mails = SentMail.dafts
      render json: @sent_mails.to_json(:only => [ :id, :subject, :sent_dateTime, :daft, :urgent, :confirmation, :created_at ])
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
      render json: @sent_mails.to_json(:only => [ :id, :subject, :sent_dateTime, :daft, :urgent, :confirmation, :created_at ])
    end

  end

  #dafts and urgents
  def daftAndUrgent
    if params[:id] != nil
      @daftUrgent = SentMail.daftAndUrgentId(params[:id])
      if SentMail.daftAndUrgentId(params[:id]).length == 0
        render status: 404
      else
        render json: @daftUrgent
      end
    else
      @sent_mails = SentMail.daftAndUrgent
      render json: @sent_mails.to_json(:only => [ :id, :subject, :sent_dateTime, :daft, :urgent, :confirmation, :created_at ])
    end

  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sent_mail
    @sent_mail = SentMail.sentId(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def sent_mail_params
    params.require(:sent_mail).permit(:sender, :recipient, :cc, :distribution_list, :subject, :message_body, :attachment, :sent_dateTime, :daft, :urgent, :confirmation)
  end

end

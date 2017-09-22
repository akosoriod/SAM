class ReceivedMailsController < ApplicationController
  before_action :set_received_mail, only: [:show, :update, :destroy]

  # GET /received_mails
  def index
    @received_mails = ReceivedMail.all

    render json: @received_mails
  end

  # GET /received_mails/1
  def show
    render json: @received_mail
  end

  # POST /received_mails
  def create
    @received_mail = ReceivedMail.new(received_mail_params)

    if @received_mail.save
      render json: @received_mail, status: :created, location: @received_mail
    else
      render json: @received_mail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /received_mails/1
  #def update
  #  if @received_mail.update(received_mail_params)
  #    render json: @received_mail
  #  else
  #    render json: @received_mail.errors, status: :unprocessable_entity
  #  end
  #end

  # DELETE /received_mails/1
  def destroy
    @received_mail.destroy
  end

  # GET /inbox/sender/nombre
  def by_sender
    @received_mails = ReceivedMail.where(Sender: params[:sender])
    if @received_mails.blank?
      #render plain: "Not mails from " + params[:sender].to_s + " found", status: 404
      render json: {message: "Not mails from " + params[:sender].to_s + " found", status: 404}, status:404
      return 1
    end
    render json: @received_mails
  end

  # GET /inbox/read
  def read
    @received_mails = ReceivedMail.where(Read: true)
    render json: @received_mails
  end

  # GET /inbox/unread
  def unread
    @received_mails = ReceivedMail.where(Read: false)
    render json: @received_mails
  end

  # GET /inbox/urgent
  def urgent
    @received_mails = ReceivedMail.where(Urgent: true)
    render json: @received_mails
  end

  # GET /inbox/not_urgent
  def not_urgent
    @received_mails = ReceivedMail.where(Urgent: false)
    render json: @received_mails
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_received_mail
      @received_mail = ReceivedMail.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def received_mail_params
      params.require(:received_mail).permit(:Sender, :Recipient, :Cc, :Distribution_list, :Subject, :Message_body, :Attachments, :Sent_dateTime, :Created_dateTime, :Read, :Urgent)
    end
end

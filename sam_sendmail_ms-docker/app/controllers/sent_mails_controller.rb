class SentMailsController < ApplicationController
  before_action :set_sent_mail, only: [:show, :update, :destroy]

  # GET /sent_mails
  def index
    @sent_mails = SentMail.all

    render json: @sent_mails
  end

  # GET /sent_mails/1
  def show
    render json: @sent_mail
  end

  # POST /sent_mails
  def create
    @sent_mail = SentMail.new(sent_mail_params)
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
    @sent_mail.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sent_mail
      @sent_mail = SentMail.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sent_mail_params
      params.require(:sent_mail).permit(:sender, :recipient, :cc, :distribution_list, :subject, :message_body, :attachment, :sent_dateTime, :daft, :urgent, :confirmation)
    end
end

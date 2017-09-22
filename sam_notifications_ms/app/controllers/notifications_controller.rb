class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :update, :destroy]

  # GET /notifications
  def index
    @notifications = Notification.all
    render json: @notifications
  end

  def set_app
    app = Rpush::Gcm::App.new
    app.name = "android_app"
    app.auth_key = "..."
    app.connections = 1
    app.save!
  end

  def create_push(username, sender)
    if !Rpush::Gcm::App.find_by_name("android_app")
      set_app
    else
      @devices = UserDevice.get_device_id(username)
      for i in @devices
        n = Rpush::Gcm::Notification.new
        n.app = Rpush::Gcm::App.find_by_name("android_app")
        n.registration_ids = [i.device_id]
        n.data = { message: "You got a new message from!"+sender}
        n.save!
        Rpush.push
        Rpush.apns_feedback
        puts i.device_id
      end
    end
  end

  # GET /notifications/1
  def show
    render json: @notification
  end

  # POST /notifications
  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      create_push(@notification.username, @notification.sender)
      #render json: @notification, status: :created, location: @notification
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notifications/1
  def update
    if @notification.update(notification_params)
      render json: @notification
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notifications/1
  def destroy
    @notification.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = Notification.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def notification_params
    params.require(:notification).permit(:username, :sender)
  end
end

class UserDevicesController < ApplicationController
  before_action :set_user_device, only: [:show, :update, :destroy]

  # GET /user_devices
  def index
    @user_devices = UserDevice.all

    render json: @user_devices
  end

  # GET /user_devices/1
  def show
    render json: @user_device
  end

  # POST /user_devices
  def create
    @user_device = UserDevice.new(user_device_params)
    if @user_device.save
      render json: @user_device, status: :created, location: @user_device
    else
      render json: @user_device.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_devices/1
  def update
    if @user_device.update(user_device_params)
      render json: @user_device
    else
      render json: @user_device.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_devices/1
  def destroy
    @user_device.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_device
      @user_device = UserDevice.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_device_params
      params.require(:user_device).permit(:username, :device_id)
    end
end

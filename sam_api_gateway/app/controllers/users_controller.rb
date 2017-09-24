class UsersController < ApplicationController

  skip_before_action :validate_token, only: [:create_user, :index_user, :show_user]

    def create_user
      user = HTTParty.post(ms_ip("rg")+"/users/create", body: {
          firstName: params[:first_name], lastName: params[:last_name],
          userName: params[:username], password: params[:password],
          gender: params[:gender], dateBirth: params[:date_birth],
          mobilePhone: params[:mobile_phone],
          currentEmail: params[:current_email], location: params[:location]
      }.to_json)
    end

    def index_user
      results = HTTParty.get(ms_ip("rg")+"/users")
      return results
    end

    def show_user(id)
      results = HTTParty.get(ms_ip("rg")+"/users/" + id.to_s)
      return results
    end

    def update_user(id)
      user = HTTParty.put(ms_ip("rg")+"/users/update" + id.to_s, body: {
          firstName: params[:first_name], lastName: params[:last_name],
          userName: params[:username], password: params[:password],
          gender: params[:gender], dateBirth: params[:date_birth],
          mobilePhone: params[:mobile_phone],
          currentEmail: params[:current_email], location: params[:location]
      }.to_json , headers:{
        "Authorization": request.headers['AUTHORIZATION']})
    end

    def destroy_user
      results = HTTParty.delete(ms_ip("rg")+"/users/destroy/" + id.to_s ,
      headers:{ "Authorization": request.headers['AUTHORIZATION']})
      return results
    end

end

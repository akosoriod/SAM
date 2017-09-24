class UsersController < ApplicationController

  skip_before_action :validate_token, only: [:create_user, :index_user, :show_user]

# No dependen del token
    def create_user
      user = {firstName: params[:first_name], lastName: params[:last_name],
          userName: params[:username], password: params[:password],
          gender: params[:gender], dateBirth: params[:date_birth],
          mobilePhone: params[:mobile_phone],
          currentEmail: params[:current_email], location: params[:location]
      }.to_json
      create_user = HTTParty.post(ms_ip("rg")+"/users",body: user)
      if create_user.code == 200
        render status: 200, json: {body:{message: "Usuario creado"}}.to_json
      else
        render create_user.code
      end
    end

    def index_user
      results = HTTParty.get(ms_ip("rg")+"/users")
      render json: results.body, status: results.code
    end

    def show_user
      results = HTTParty.get(ms_ip("rg")+"/users/"+ params[:id].to_s)
      render json: results.body, status: results.code
    end

# Dependen del token

    def update_user
      user = HTTParty.put(ms_ip("rg")+"/users/update" + params[:id].to_s, body: {
          firstName: params[:first_name], lastName: params[:last_name],
          userName: params[:username], password: params[:password],
          gender: params[:gender], dateBirth: params[:date_birth],
          mobilePhone: params[:mobile_phone],
          currentEmail: params[:current_email], location: params[:location]
      }.to_json , headers:{
        "Authorization": request.headers['AUTHORIZATION']})
    end

    def destroy_user
      results = HTTParty.delete(ms_ip("rg")+"/users/destroy/" +params[:id].to_s,
      headers:{ "Authorization": request.headers['AUTHORIZATION']})
      if results.code == 200
        render status: 200, json: {body:{message: "Usuario borrado"}}.to_json
      else
        render status: 404, json: {body:{message: "El usuario no ha podido ser borrado"}}.to_json
      end
    end

end

class SessionsController < ApplicationController

skip_before_action :validate_token, only: [:refresh_token, :login]

  def login
    login = HTTParty.post(ms_ip("rg")+"/users/login", body: {
      userName: params[:username],
      password: params[:password]
    }.to_json,
      :headers => { 'Content-Type' => 'application/json' })
    if login.code == 200
      token = HTTParty.get(ms_ip("ss")+"/token/"+params[:username])
      puts token.body
      render status: token.code, json: token.body
    else
      render status: 404
    end
  end

  def refresh_token
    puts ms_ip("ss") + "/refresh"
    results = HTTParty.get(ms_ip("ss") + "/refresh", headers:{
      "Authorization": request.headers['AUTHORIZATION']
      })
      render status: results.code, json: results.body
  end

end

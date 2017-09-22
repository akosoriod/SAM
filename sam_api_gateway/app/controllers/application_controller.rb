class ApplicationController < ActionController::API

   before_action :require_token

   protected

   def require_token
    rsa_public = OpenSSL::PKey::RSA.new File.read 'rsa_keys/public.rsa.pub'

    token = request.headers['AUTHORIZATION']
    begin
      decoded_token = JWT.decode token, rsa_public, true, { :algorithm => 'RS256' }
    rescue Exception
      render status: 401
      return 1
    end
    render status: 401 if decoded_token[0]["typ"] != "Authorization"
  end

  def get_host
    "192.168.0.102"
  end

end

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = verified_user!
    end

    private

    def verified_user!
      raw_token = request.headers["Authorization"] || "Bearer #{request.params[:token]}"
      reject_unauthorized_connection unless raw_token
      token = raw_token.split(" ")[1]
      decoded_token = JWT.decode(token, ENV["JWT_SECRET"], true, { algorithm: "HS256" })
      payload = decoded_token[0]
      @user = User.find_by(id: payload["user_id"])
      reject_unauthorized_connection unless @user
      @user
    rescue JWT::ExpiredSignature
      reject_unauthorized_connection
    rescue JWT::DecodeError
      reject_unauthorized_connection
    end
  end
end

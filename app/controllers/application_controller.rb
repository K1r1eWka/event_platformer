class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

  def authenticate_user!
    raw_token = request.headers["Authorization"]
    return render json: { error: "unauthorized" }, status: :unauthorized unless raw_token
    token = raw_token.split(" ")[1]
    decoded_token = JWT.decode(token, ENV["JWT_SECRET"], true, { algorithm: "HS256" })
    payload = decoded_token[0]
    @user = User.find_by(id: payload["user_id"])
    render json: { "error": "unauthorized" }, status: :unauthorized unless @current_user = @user
  rescue JWT::ExpiredSignature
    render json: { "error": "unauthorized" }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { "error": "unauthorized" }, status: :unauthorized
  end

  def current_user
    @current_user
  end

  private

  def record_not_found
    render json: { error: "Not found" }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end

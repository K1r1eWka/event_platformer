class WelcomeEmailJob < ApplicationJob
  sidekiq_options retry: 3
  queue_as :critical

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user
    UserMailer.welcome_email(user).deliver_now
  end
end

class WelcomeEmailJob < ApplicationJob
  sidekiq_options retry: 3
  queue_as :critical

  def perform(user_id)
    Rails.logger.info("Started welcome email job for user=#{user_id}")
    user = User.find_by(id: user_id)
    unless user
      Rails.logger.warn("User by id=#{user_id} not found!")
      return
    end
    UserMailer.welcome_email(user).deliver_now
    Rails.logger.info("Send the welcome mail and plain text for user=#{user_id}")
  end
end

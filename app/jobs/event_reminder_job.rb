class EventReminderJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    Rails.logger.info("Started event reminder job for event=#{event_id}")
    event = Event.find_by(id: event_id)
    unless event
      Rails.logger.warn("Event by id=#{event_id} not found!")
      return
    end
    users = User.joins(tickets: :zone).where(zones: { event_id: event.id }).distinct
    users.each do |user|
      UserMailer.reminder_email(event, user).deliver_now
      Rails.logger.info("Send the reminder email and plain text for user=#{user.id}")
    end
  end
end

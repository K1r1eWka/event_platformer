class EventReminderJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find_by(id: event_id)
    return unless event
    users = User.joins(tickets: :zone).where(zones: { event_id: event.id }).distinct
    users.each do |user|
      UserMailer.reminder_email(event, user).deliver_now
    end
  end
end

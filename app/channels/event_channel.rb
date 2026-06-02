class EventChannel < ApplicationCable::Channel
  def subscribed
    stream_from "event_#{params[:event_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

class EventSerializer
  def initialize(event)
    @event = event
  end

  def as_json
    {
      id: @event.id,
      title: @event.title,
      description: @event.description,
      location: @event.location,
      duration_minutes: @event.duration_minutes,
      starts_at: @event.starts_at,
      ends_at: @event.starts_at + @event.duration_minutes.minutes,
      organizer: @event.organizer ? { id: @event.organizer.id, first_name: @event.organizer.first_name, last_name: @event.organizer.last_name } : nil
    }
  end
end

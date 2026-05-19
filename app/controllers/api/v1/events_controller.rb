class Api::V1::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :show, :update, :destroy ]
  before_action :check_organizer, only: [ :update, :destroy ]


  def index
    @events = Event.includes(:organizer).where("starts_at > ?", Time.current)
    events = @events.map { |event| EventSerializer.new(event).as_json }
    render json: events
  end

  def show
    event = EventSerializer.new(@event)
    render json: event.as_json
  end

  def create
    @event = Event.new(event_params)
    @event.organizer = current_user
    @event.save!
    EventReminderJob.set(wait_until: @event.starts_at - 1.day).perform_later(@event.id)
    event = EventSerializer.new(@event)
    render json: event.as_json, status: :created
  end

  def update
    @event.update!(event_params)
    event = EventSerializer.new(@event)
    render json: event.as_json
  end

  def destroy
    @event.destroy
    head :no_content
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :starts_at, :location, :duration_minutes)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def check_organizer
    render json: { "error": "permission denied" }, status: :forbidden unless current_user.id == @event.user_id
  end
end

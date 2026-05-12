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
    if @event.save
      event = EventSerializer.new(@event)
      render json: event.as_json, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      event = EventSerializer.new(@event)
      render json: event.as_json
    else
      render json: @event.errors, status: :unprocessable_entity
    end
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
    if current_user.id != @event.user_id
      render json: { "error": "permission denied" }, status: :forbidden
    end
  end
end

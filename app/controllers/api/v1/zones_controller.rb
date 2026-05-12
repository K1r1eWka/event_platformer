class Api::V1::ZonesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_organizer, only: [ :create ]

  def index
    @zones = @event.zones
    render json: @zones
  end
  def show
    @zone = @event.zones.find(params[:id])
    render json: @zone
  end
  def create
    @zone = @event.zones.new(zone_params)
    if @zone.save
      render json: @zone, status: :created
    else
      render json: @zone.errors, status: :unprocessable_entity
    end
  end

  private

  def zone_params
    params.require(:zone).permit(:name, :capacity, :price)
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def check_organizer
    render json: { "error": "permission denied" }, status: :forbidden unless @event.user_id == current_user.id
  end
end

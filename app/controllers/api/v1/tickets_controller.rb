class Api::V1::TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :create, :index ]
  before_action :set_zone, only: [ :create ]

  def index
    @tickets = @event.tickets
    render json: @tickets
  end
  def create
    @ticket = @zone.tickets.new
    @ticket.user_id = current_user.id
    if @ticket.save
      render json: @ticket, status: :created
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end
  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.user_id = current_user.id
      if @ticket.update(ticket_params)
        render json: @ticket
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    else
      render json: { "error": "permission denied" }, status: :forbidden
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_zone
    @zone = @event.zones.find(params[:zone_id])
  end

  def ticket_params
    params.require(:ticket).permit(:status)
  end
end

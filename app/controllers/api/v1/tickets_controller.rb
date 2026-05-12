class Api::V1::TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :create, :index ]
  before_action :set_zone, only: [ :create ]
  before_action :check_ticket_owner, only: [ :update ]

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
    if @ticket.update(ticket_params)
      render json: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_entity
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

  def check_ticket_owner
    @ticket = Ticket.find(params[:id])
    render json: { "error": "permission denied" }, status: :forbidden unless @ticket.user_id == current_user.id
  end
end

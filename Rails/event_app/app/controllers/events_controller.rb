class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy,]

  before_action :set_event_by_id, only:[:accept_request, :reject_request]
  before_filter :authenticate_user!
  before_action :event_owner!, only: [:edit, :update, :destroy]
  before_action :not_event_owner!, only: [:join]

  respond_to :html
  # GET /events
  # GET /events.json
  def index
    if params[:tag]
      @events = Event.tagged_with(params[:tag])
    elsif params[:search]
      @events = Event.contain_tag(params[:search])
    else
      @events = Event.all
    end

  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event_owners = @event.organizer
    @attendees = Event.show_accepted_attendees(@event.id)
    @pending_requests = Attendance.pending.where(event_id: @event.id)
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.organized_events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join
    @event = Event.find(params[:event_id])
    @attendance =
        Attendance.join_event(current_user.id,
                              params[:event_id], 'request_sent')
    respond_to do |format|
      format.html { redirect_to @event, notice: 'Resuest Send' }
      format.json { render :show, status: :created, location: @event }
    end
  end

  def accept_request
    @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
    @attendance.accept!
    'Applicant Accepted' if @attendance.save
    respond_to do |format|
      format.html { redirect_to @event, notice: 'Applicant Accepted' }
      format.json { render :show, status: :created, location: @event }
    end
  end

  def reject_request
    @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
    @attendance.reject!
    'Applicant Rejected' if @attendance.save
    respond_to do |format|
      format.html { redirect_to @event, notice: 'Applicant Rejected' }
      format.json { render :show, status: :created, location: @event }
    end
  end

  def my_events
    @events = current_user.organized_events
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :start_date, :end_date,
                                    :location, :agenda, :address,
                                    :organizer_id, :all_tags)
    end

    def event_owner!
      authenticate_user!
      unless is_owner?
        redirect_to events_path
        flash[:notice] =  'You do not have enough permissions to do this'
      end
    end

  def not_event_owner!
    authenticate_user!
    if is_owner?
      redirect_to events_path
      flash[:notice] =  'You do not have enough permissions to do this'
    end
  end

    def set_event_by_id
      @event = Event.find(params[:event_id])
    end

    def is_owner?
      @event.organizer_id == current_user.id
    end
end


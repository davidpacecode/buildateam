class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]

  # GET /teams or /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new

    players_taken = []
    temp_array = []

    @pg_id ||= Player.who_play("PG").sample(1).first.id
    players_taken << @pg_id

    ["SG","SF","PF","C"].each do |pos|
      temp_array = Player.who_play(pos)
      temp_array -= players_taken
      instance_variable_set("@#{pos.downcase}_id", temp_array.sample(1).first.id)
      players_taken << instance_variable_get("@#{pos.downcase}_id")
      temp_array.clear
    end
  end

  # GET /teams/1/edit
  def edit

    players_remaining = 0
    players_remaining += 1 if @team.pg_id != 0
    players_remaining += 1 if @team.sg_id != 0
    players_remaining += 1 if @team.sf_id != 0
    players_remaining += 1 if @team.pf_id != 0
    players_remaining += 1 if @team.c_id != 0

    if players_remaining == 0
      redirect_to teams_path, notice: "Team is full."
    end

    unique_random_numbers = (1..100).to_a
    unique_random_numbers.delete(@team.pg_id) if @team.pg_id != 0
    unique_random_numbers.delete(@team.sg_id) if @team.sg_id != 0
    unique_random_numbers.delete(@team.sf_id) if @team.sf_id != 0
    unique_random_numbers.delete(@team.pf_id) if @team.pf_id != 0
    unique_random_numbers.delete(@team.c_id) if @team.c_id != 0
    unique_random_numbers.sample(players_remaining)

    @team.pg_id == 0 ? @pg_id ||= 99 : @pg_id = @team.pg_id
    @team.sg_id == 0 ? @sg_id ||= 99 : @sg_id = @team.sg_id
    @team.sf_id == 0 ? @sf_id ||= 99 : @sf_id = @team.sf_id
    @team.pf_id == 0 ? @pf_id ||= 99 : @pf_id = @team.pf_id
    @team.c_id == 0 ? @c_id ||= 99 : @c_id = @team.c_id
   end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)

    @team.session_token = session[:token]
    @team.ip_address = request.remote_ip

    @team.pg_id = 0 unless params[:team][:position] == "pg"
    @team.sg_id = 0 unless params[:team][:position] == "sg"
    @team.sf_id = 0 unless params[:team][:position] == "sf"
    @team.pf_id = 0 unless params[:team][:position] == "pf"
    @team.c_id = 0 unless params[:team][:position] == "c"

    respond_to do |format|
      if @team.save
        format.html { redirect_to edit_team_path(@team), notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: "Team was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy!

    respond_to do |format|
      format.html { redirect_to teams_path, notice: "Team was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.expect(team: [ :pg_id, :sg_id, :sf_id, :pf_id, :c_id, :session_token, :ip_address ])
    end
end

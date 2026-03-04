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

    unique_random_numbers = (1..100).to_a.sample(5)
    @pg_id ||= unique_random_numbers[0]
    @sg_id ||= unique_random_numbers[1]
    @sf_id ||= unique_random_numbers[2]
    @pf_id ||= unique_random_numbers[3]
    @c_id  ||= unique_random_numbers[4]
  end

  # GET /teams/1/edit
  def edit
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
        format.html { redirect_to @team, notice: "Team was successfully created." }
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

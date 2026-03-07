class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]

  # GET /teams or /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1 or /teams/1.json
  def show
    @pg_id = @team.pg_id
    @sg_id = @team.sg_id
    @sf_id = @team.sf_id
    @pf_id = @team.pf_id
    @c_id = @team.c_id
  end

  # GET /teams/new
  def new
    @team = Team.new

    @new_team = true
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

    @new_team = false
    temp_array = []

    ["pg", "sg", "sf", "pf", "c"].each do |pos|
      if @team.send("#{pos}_id") == 0
        temp_array = Player.who_play(pos)
        temp_array -= @team.players
        instance_variable_set("@#{pos.downcase}_id", temp_array.sample(1).first.id)
        temp_array.clear
      else
        instance_variable_set("@#{pos.downcase}_id", @team.send("#{pos}_id"))
      end
    end

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
      # @team.send("#{params[:team][:position]}_id") == "#{params[:team][:position]}_id"
      case params[:team][:position]
      when "pg"
        @team.pg_id = params[:team][:pg_id]
      when "sg"
        @team.sg_id = params[:team][:sg_id]
      when "sf"
        @team.sf_id = params[:team][:sf_id]
      when "pf"
        @team.pf_id = params[:team][:pf_id]
      when "c"
        @team.c_id = params[:team][:c_id]
      else
        "something went wrong"
      end

      if @team.save
        if @team.open_spots_left == 0
          format.html { redirect_to @team, notice: "Team was successfully updated.", status: :see_other }
          format.json { render :show, status: :ok, location: @team }
        else
          redirect_to edit_team_path(@team), notice: "Team was successfully updated."
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end

    # respond_to do |format|
    #   if @team.update(team_params)
    #     if @team.open_spots_left == 0
    #       format.html { redirect_to @team, notice: "Team was successfully updated.", status: :see_other }
    #       format.json { render :show, status: :ok, location: @team }
    #     else
    #       redirect_to edit_team_path(@team), notice: "Team was successfully updated."
    #     end
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @team.errors, status: :unprocessable_entity }
    #   end
    # end
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

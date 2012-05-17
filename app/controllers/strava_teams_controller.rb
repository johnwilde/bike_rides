class StravaTeamsController < ApplicationController
  
  def index
    @strava_teams = StravaTeam.paginate(:page => params[:page])
    @title = "All teams"
  end
  
  def show
    @strava_team = StravaTeam.find(params[:id])
    @title = @strava_team.team_name
  end

  def new
    @strava_team  = StravaTeam.new
    @title = "Load a team from Strava"
  end
  
  def create
    team_params = StravaTeam.search_strava_for_team_name(params[:strava_team][:team_name])
    render 'new' if team_params.nil?
    @strava_team = StravaTeam.new(team_params)
    if @strava_team.save
      redirect_to @strava_team, :flash => { :success => "Team created. Click to process (may take a while for a large team!)." }
    else
      render 'new'
    end
  end
  
  def destroy
    @strava_team = StravaTeam.find(params[:id])
    @strava_team.destroy
    redirect_to strava_teams_path, :flash => { :success => "Team destroyed." }
  end

  def update
    @strava_team = StravaTeam.find(params[:id])
    @strava_team.update_members
    redirect_to @strava_team, :flash => { :success => "Updated Results" }
  end
end

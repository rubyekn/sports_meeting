class TeamsController < ApplicationController

  def index
    @teams=[]
    @team=[]
    @team+=Team.all
    @groups=["A","B","C","D"]
    @groups.each do |tp|
      @temp=[]
      @team.each do |t|
        if t.group==tp
          @temp<<t
        end
      end
      @temp.sort_by!{|e| e.points}
      @teams+=@temp
    end
  end

  def new
    @team=Team.new
  end

  def create
    @team=Team.new(params.require(:team).permit(:name,:points,:group))

    @team.save

    if @team.save
      redirect_to @team
    else
      render 'new'
    end
  end

  def show
    @team=Team.find(params[:id])

  end

  def edit
    @team=Team.find(params[:id])
  end

  def update
    @team=Team.find(params[:id])

    if @team.update(team_params)
      redirect_to @team
    else
      render 'edit'
    end
  end

  def destroy
    @team=Team.find(params[:id])
    @team.destroy
    redirect_to @team
  end

  private
  def team_params
    params.require(:team).permit(:name,:points,:group)
  end
end

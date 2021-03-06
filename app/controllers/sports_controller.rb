class SportsController < ApplicationController

  def index
    @sports=Sport.all
  end

  def check
    if current_user
      Sport.check()
    end
  end

  def new
    if current_user
      @sport=Sport.new
      @sport.status = "已结束"
      @sport.winner = "0"
      @sport.loser = "0"
      @sport.week = "校历第五周"
      @sport.wday = "星期日"
    else
      redirect_to :root
    end
  end

  def forenotice
    @sports=Sport.where("status=?", "未开始")
  end

  def interest
  end

  def interesting
    if params[:category]
      @sports=[]
      @sports+=Sport.where("title=?","趣味项目:"+params[:category])
      unless @sports.empty?
        begin
          unless @sports.last.wp.include? ":"
            @sports.sort_by! {|x| x.wp.to_i*(-1)}
          else
            @sports.sort_by! {|x| x.wp}
          end
        rescue
          #Do Nothing
        end
      end
      respond_to do |f|
        f.js
      end
    end
  end

  def create
    if current_user
      @sport = Sport.new(params.require(:sport).permit(:title,:teamone,:winner,:loser,:teamtwo,:wp,:lp,:week,:wday,:status,:hour,:minute,:place))
      @category=Category.find_by_name(@sport.title)||Category.create(name:@sport.title)
      @sport.category=@category
      teams=[]
      teams<<@sport.teamone<<@sport.teamtwo
      for team in teams.compact
        @team=Team.where(name:team,category:@category).last||@category.teams.create({name:team,points:0,group:""})
        @sport.teams<<@team
      end
      @sport.save

      if @sport.save
        redirect_to @sport
      else
        render 'new'
      end
    end
  end

  def destroy
    if current_user
      @sport = Sport.find(params[:id])
      @sport.destroy
      redirect_to @sport
    else
      redirect_to :root
    end
  end

  def show
    if current_user
      @sport= Sport.find(params[:id])
    else
      redirect_to :root
    end
  end

  def edit
    if current_user
      @sport= Sport.find(params[:id])
    else
      redirect_to :root
    end
  end

  def update
    if current_user
      @sport= Sport.find(params[:id])
      if @sport.update(sport_params)
        @category=Category.find_by_name(@sport.title)||Category.create(name:@sport.title)
        @sport.category=@category
        for former_team in @sport.teams
          former_team.sports.delete(@sport)
        end
        teams=[]
        teams<<@sport.teamone<<@sport.teamtwo
        for team in teams.compact
          @team=@category.teams.where(name:team).last||@category.teams.create({name:team,points:0,group:""})
          @sport.teams<<@team
        end
        @sport.save
        redirect_to @sport
      else
        render 'edit'
      end
    else
      redirect_to :root
    end
  end

  def search
    dic={"校历第五周"=>1,"校历第六周"=>2,"校历第七周"=>3,"校历第八周"=>4,"校历第九周"=>5,"校历第十周"=>6}
    dic2={"星期一"=>1,"星期二"=>2,"星期三"=>3,"星期四"=>4,"星期五"=>5,"星期六"=>6,"星期日"=>7}
    @nsports=[]
    @advance=[]
    @final=[]
    @sports=[]
    if params[:search][:key]
      Sport.all.each do |sport|
        if sport.teamone.include? params[:search][:key] or (sport.teamtwo||="").include? params[:search][:key]
          if (sport.wday||="").include? params[:search][:wday_] and (sport.week||="").include? params[:search][:week_] and sport.title.include? params[:search][:title]
            unless sport.title.include? "趣味"# or sport.status=="未开始"
              if sport.teamone.include? "强"
                @advance<<sport
              elsif sport.teamone.include? "决"
                @final<<sport
              else
                @nsports<<sport
              end
            end
          end
        end
      end
    end
    @advance.sort_by!{|e| dic[e.week]*7+dic2[e.wday]}
    @final.sort_by!{|e| dic[e.week]*7+dic2[e.wday]}
    @nsports.sort_by!{|e| dic[e.week]*7+dic2[e.wday]}
    @sports+=@final
    @sports+=@advance
    @sports+=@nsports
  end


  private
  def sport_params
    params.require(:sport).permit(:title,:winner,:loser,:teamone,:teamtwo,:wp,:lp,:week,:wday,:status,:hour,:minute,:place,:interest)
  end

  def search_params
    params.require(:search).permit(:key,:week_,:wday_,:title)
  end
end

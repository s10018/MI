# -*- coding: utf-8 -*-
class MoviesController < ApplicationController
  include MovieHelper
  
  $scale = 0.20
  $width = 640
  $height = 480

  $select_order_list = [['降順','d'],
                        ['昇順','a']]
  $max_camera = 16
  $camera_list = [1,2,3,4,5,6,
                  7,8,10,12,15,16,
                  17,19,20,22]
  def index
    @alltag = Movie.tag_counts_on(:tags).order('count DESC')
    @date = '2013-02-20'
    @order = 'a'
    @page = 1
    @mode = "date"
    @showed = "list"
    @list = Movie.order_by_date(@date, @order).page(@page).order("camera")    
    @time = get_info(@list[0],"time").gsub('-',':')
    session[:date] = @date
    session[:showed] = @showed
    session[:order] = @order
    session[:mode] = @mode
  end
  
  def show
    @movie = Movie.find(params[:id])
    render :layout => false
  end
  
  def page
    @page = params[:page]
    @alltag = Movie.tag_counts_on(:tags).order('count DESC')
    if @page && session[:mode] == "date"
      @date = session[:date]
      @showed = params[:showed_page]
      @order = 'a'
      @mode = "date"
      session[:showed] = @showed
      @list = Movie.order_by_date(@date, @order).page(@page).order("camera")
      if @list != []
        @time = get_info(@list[0],"time").gsub('-',':')
      end
    elsif @page && session[:mode] == "tag"
      @tags = session[:tags]
      @showed = 'list'
      @mode = "tag"
      @list = Movie.tagged_with(@tags,:any => true).page(@page)
      @time = ""
    elsif @page && session[:mode] == "camera"
      @camera = session[:camera]
      @showed = "list"
      @mode = "camera"
      @order = 'a'    
      session[:camera] = @camera
      @list = Movie.camera_date(@camera, @date, @order).page(@page)
      @time = ""
    elsif @page && session[:mode] == "part"
      @part = session[:part]
      @date = session[:date]
      @showed = params[:showed_page]
      @mode = "part"
      @order = 'a'
      session[:showed] = @showed
      @list = Movie.part(@date, @part, @order).page(@page)
      if @list != []
        @time = get_info(@list[0],"time").gsub('-',':')
      end
    end
    render :template => "movies/index"    
  end

  def search
    @alltag = Movie.tag_counts_on(:tags).order('count DESC')
    @tags = params[:tag]
    @showed = "list"
    @mode = "tag"
    @page = 1
    session[:tags] = @tags
    session[:mode] = @mode
    session[:showed] = @showed
    # any : 含むものすべて(OR)
    # match_all : すべて含むもの (AND)
    if(params[:search_mode] && params[:search_mode] == "AND")
      @list = Movie.tagged_with(@tags.split(" "), :match_all => true)
        .page(@page)
        .order('date')
    else
      @list = Movie.tagged_with(@tags.split(" "), :any => true)
        .page(@page)
        .order('date')
    end
    render :template => "movies/index"
  end
  
  def camera
    @alltag = Movie.tag_counts_on(:tags).order('count DESC')
    @camera = params[:camera]
    @page = 1
    @showed = "list"
    @mode = "camera"
    @order = 'a'    
    @list = Movie.camera_date(@camera, @date, @order).page(1)
    session[:mode] = @mode
    session[:camera] = @camera
    render :template => "movies/index"    
  end
  
  def date
    @alltag = Movie.tag_counts_on(:tags).order('count DESC')
    @date = params[:date]
    @page = 1
    @showed = params[:showed_date]
    @mode = "date"
    @order = 'a'
    session[:date] = @date
    session[:showed] = @showed
    session[:order] = @order
    session[:mode] = @mode
    @list = Movie.order_by_date(@date, @order).page(1).order("camera")
    if @list != []
      @time = get_info(@list[0],"time").gsub('-',':')
    end
    render :template => "movies/index"
  end

  def part
    @alltag = Movie.tag_counts_on(:tags).order('count DESC')
    @part = params[:part]
    @date = params[:part_date]
    @page = 1
    @showed = params[:showed]
    @mode = "part"
    @order = 'a'
    session[:date] = @date
    session[:part] = @part
    session[:showed] = @showed
    session[:order] = @order
    session[:mode] = @mode
    @list = Movie.part(@date, @part, @order).page(1)
    if @list != []
      @time = get_info(@list[0],"time").gsub('-',':')
    end
    render :template => "movies/index"    
  end
  
  def add_tag
    add_tag = params[:addtag]
    status = "error"
    sucess = ""
    if(add_tag != "")
      @movie = Movie.find(params[:id])
      @movie.tag_list << add_tag
      if(@movie.save)
        status = "success"
        success = "「#{add_tag}」を追加しました"
      end
    end
    @movie = Movie.find(params[:id])
    render :json => {
      :status => status,
      :success => success,
      :elem => "#tag_info#{@movie.id}",
      :tags => @movie.tag_list
    }
  end

  def allupdate
    Movie.all_update
    redirect_to :action => "index"
  end
  
end




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
    @list = Movie.range_date(@date, @order).page(@page).order("camera")
    if @list.size > 0
      @time = get_info(@list[0],"time").gsub('-',':')
    end
    session[:date] = @date
    session[:showed] = @showed
    session[:order] = @order
    session[:mode] = @mode
  end
  
  def show
    @movie = Movie.find(params[:id])
    render :layout => false
  end

  def tag
    @alltag = Movie.tag_counts_on(:tags).order('count DESC')
    @tags = params[:tag]
    @showed = "list"
    @mode = "tag"
    if params[:page]
      @page = params[:page]
    else
      @page = 1
    end
    session[:tags] = @tags
    session[:mode] = @mode
    session[:showed] = @showed
    # any : 含むものすべて(OR)
    # match_all : すべて含むもの (AND)
    if(params[:search_mode] && @tags.split(" ") > 0 && params[:search_mode] == "AND")
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
    if params[:page]
      @page = params[:page]
    else
      @page = 1
    end
    @showed = "list"
    @mode = "camera"
    @order = 'a'    
    @list = Movie.camera_date(@camera, @date, @order).page(@page)
    session[:mode] = @mode
    session[:camera] = @camera
    render :template => "movies/index"    
  end
  
  def date
    @alltag = Movie.tag_counts_on(:tags).order('count DESC')
    @date = params[:date]
    if params[:page]
      @page = params[:page]
      @showed = params[:showed]
    else
      @page = 1
      @showed = params[:showed_date]
    end
    @mode = "date"
    @order = 'a'
    session[:date] = @date
    session[:showed] = @showed
    session[:order] = @order
    session[:mode] = @mode
    @list = Movie.range_date(@date, @order).page(@page).order("camera")
    if @list != []
      @time = get_info(@list[0],"time").gsub('-',':')
    end
    render :template => "movies/index"
  end

  def part
    @alltag = Movie.tag_counts_on(:tags).order('count DESC')
    @part = params[:part]
    @date = params[:part_date]
    if params[:page]
      @page = params[:page]
    else
      @page = 1
    end
    @showed = params[:showed]
    @mode = "part"
    @order = 'a'
    session[:date] = @date
    session[:part] = @part
    session[:showed] = @showed
    session[:order] = @order
    session[:mode] = @mode
    @list = Movie.part(@date, @part, @order).page(@page)
    if @list != []
      @time = get_info(@list[0],"time").gsub('-',':')
    end
    render :template => "movies/index"    
  end
  
  def allupdate
    Movie.all_update
    redirect_to :action => "index"
  end
  
end




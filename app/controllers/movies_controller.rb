# -*- coding: utf-8 -*-
class MoviesController < ApplicationController
  include MovieHelper
  
  $scale = 0.20
  $width = 640
  $height = 480
  $row = 3
  $column = 6
  $select_order_list = [['降順','d'],
                        ['昇順','a']]
  $max_camera = 16
  $camera_list = [1,2,3,4,5,6,
                  7,8,10,12,15,16,
                  17,19,20,22]

  def index
    @date = '2013-02-20'
    @order = 'a'
    @page = 1
    @mode = "date"
    @list = Movie.order_by_date(@date, @order).page(@page).order("camera")    
    @time = get_info(@list[0],"time").gsub('-',':')
    @showed = "list"
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
      render :template => "movies/index"
    elsif @page && session[:mode] == "tag"
      @tags = session[:tags]
      @showed = 'list'
      @mode = "tag"
      session[:showed] = @showed
      @list = Movie.tagged_with(@tags,:any => true).page(@page)
      @time = ""
      render :template => "movies/index"
    elsif @page && session[:mode] == "camera"
      @camera = session[:camera]
      @showed = "list"
      @mode = "camera"
      @order = 'a'    
      session[:camera] = @camera
      @list = Movie.camera_date(@camera, @date, @order).page(1)
      @time = ""
      render :template => "movies/index"
    end
  end

  def search
    @tags = params[:tag]
    session[:tags] = @tags
    @showed = 'list'
    @mode = "tag"
    @page = 1
    session[:mode] = @mode
    session[:showed] = @showed
    @list = Movie.tagged_with(@tags,:any => true).page(@page)
    render :template => "movies/index"
  end
  
  def camera
    @camera = params[:camera]
    @page = 1
    @showed = "list"
    @mode = "camera"
    @order = 'a'    
    session[:camera] = @camera
    session[:mode] = @mode
    @list = Movie.camera_date(@camera, @date, @order).page(1)
    render :template => "movies/index"    
  end
  
  def date
    @date = params[:date]
    @page = 1
    @showed = session[:showed_date]
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
  
  def add_tag
    add_tag = params[:addtag]
    @movie = Movie.find(params[:id])
    @movie.tag_list << add_tag
    if(@movie.save)
      render :json => {
        :sucess => "「#{add_tag}」を追加しました",
        :elem => "#tag_info#{@movie.id}",
        :tags => @movie.tag_list
      }
    end
  end

  def allupdate
    Movie.all_update
    redirect_to :action => "index"
  end

  def select
    if(params[:select_order])
      session[:save]['order'] = params[:select_order]
      session[:save]['page'] = 1
      session[:save]['tag'] = nil
      session[:save]['control'] = nil
    end
    if(params[:datepicker])
      session[:save]['date'] = params[:datepicker]
      session[:save]['control'] = nil
      session[:save]['tag'] = nil
    end
    if(params[:part])
      session[:save]['part'] = params[:part]
      session[:save]['control'] = nil
    end
    if(params[:page])
      session[:save]['page'] = params[:page]
      session[:save]['control'] = nil
    end
    if(params[:tag])
      session[:save]['tag'] = params[:tag]
      session[:save]['page'] = 1
      session[:save]['control'] = nil
    end
    if(params[:control])
      if(params[:control] != "minute-n" && params[:control] != "minute-p")
        session[:save]['control'] = params[:control]
        dd = session[:save]['date'].split(/-/)
        t = Time.mktime(dd[0],dd[1],dd[2])
        control = {
          "pm" => 1.month.ago(t), "pw" => 1.week.ago(t),
          "nm" => 1.month.since(t), "nw" => 1.week.since(t),
        }
        session[:save]['date'] = control[session[:save]['control']].strftime("%Y-%m-%d")
      else
        if(params[:control] == "minute-n")
          session[:save]['page'] = params[:page].to_i + 1
        elsif(params[:control] == "minute-p")
          session[:save]['page'] = params[:page].to_i - 1
        end
      end
    end
    redirect_to :action => "show",
    :order => session[:save]['order'],
    :target => session[:save]['target'],
    :date => session[:save]['date'],
    :control => session[:save]['control'],
    :page => session[:save]['page'],
    :tag => session[:save]['tag'],
    :part => session[:save]['part']
  end
  
end




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
    redirect_to :action => "show",
    :target => 'date',
    :date => '2012-10-22',
    :order => 'a',
    :control => nil,
    :tag => nil,
    :part => "5",
    :page => "1"
  end
  
  def show
    session[:save] = {
      'target' => params[:target],
      'date' => params[:date],
      'order' => params[:order],
      'control' => params[:control],
      'part' => params[:part],
      'tag' => params[:tag],
      'page' => params[:page]      
    }
    @target = session[:save]['target']
    @order = session[:save]['order']
    @date = session[:save]['date']
    @part = session[:save]['part'].to_i
    @page = session[:save]['page'].to_i
    @control = session[:save]['control']
    if(session[:save]['tag'])
      @list = Movie.tagged_with(session[:save]['tag'],:any => true).page(params[:page])
    else
      @list = Movie.part(@date,@part,@order).page(params[:page]).order("camera")
      if(@list.size > 0)
        a = get_info(@list[0].path,"date")
        @time = a.split("-")[3] + ":" + a.split("-")[4]
      end
    end
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
  
  def adding
    add_tag = params[:addtag]
    @movie = Movie.find(params[:id])
    @movie.tag_list << add_tag
    if(@movie.save)
      render :json => {
        :sucess => "「#{add_tag}」を追加しました",
        :elem => "#tag_info#{@movie.id}",
        :tags => "TAG:"+@movie.tag_list.join(" ") }
    end
  end

  def allupdate
    Movie.all_update
    redirect_to :action => "index"
  end
end




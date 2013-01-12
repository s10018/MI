# -*- coding: utf-8 -*-
class MoviesController < ApplicationController
  include MovieHelper
  
  $scale = 0.25
  $width = 640
  $height = 480
  $row = 3
  $column = 6
  $select_order_list = [['降順','d'],
                        ['昇順','a']]
  $max_camera = 14
  
  def index
    redirect_to :action => "show",
    :target => 'date',
    :date => '2012-10-22',
    :order => 'a',
    :control => nil,
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
      'page' => params[:page]      
    }
    @target = session[:save]['target']
    @order = session[:save]['order']
    @date = session[:save]['date']
    @part = session[:save]['part'].to_i
    @page = session[:save]['page'].to_i
    @control = session[:save]['control']
    @list = Movie.part(@date,@part,@order).page(params[:page]).order("camera")
    if(@list.size > 0)
      @time = get_info(@list[0].path,"date")
    end
  end
  
  def select
    if(params[:select_order])
      session[:save]['order'] = params[:select_order]
      session[:save]['control'] = nil
    end
    if(params[:datepicker])
      session[:save]['date'] = params[:datepicker]
      session[:save]['control'] = nil
    end
    if(params[:part])
      session[:save]['part'] = params[:part]
      session[:save]['control'] = nil
    end
    if(params[:page])
      session[:save]['page'] = params[:page]
    end
    if(params[:control])
      session[:save]['control'] = params[:control]
      dd = session[:save]['date'].split(/-/)
      t = Time.mktime(dd[0],dd[1],dd[2])
      control = { "pm" => 1.month.ago(t), "pw" => 1.week.ago(t),
        "nm" => 1.month.since(t), "nw" => 1.week.since(t) }
      session[:save]['date'] = control[session[:save]['control']].strftime("%Y-%m-%d")
    end
    redirect_to :action => "show",
    :order => session[:save]['order'],
    :target => session[:save]['target'],
    :date => session[:save]['date'],
    :control => session[:save]['control'],
    :page => session[:save]['page'],
    :part => session[:save]['part']
  end

  def outline
  end
  
  def detail
  end

  def allupdate
    Movie.all_update
    redirect_to :action => "index"
  end
end




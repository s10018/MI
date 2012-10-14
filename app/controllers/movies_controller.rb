# -*- coding: utf-8 -*-
class MoviesController < ApplicationController

  $scale = 0.25
  $width = 640
  $height = 480
  $row = 3
  $column = 6
  $select_order_list = [['降順','d'],
                        ['昇順','a']]
  $max_camera = 14
  
  def index
    redirect_to :action => "show", :target => 'date', :date => '2012-09-20-19-00', :order => 'd', :part => "3", :page => "1"
  end
  
  def show
    session[:save] = {'target' => params[:target], 'date' => params[:date], 'order' => params[:order], 'part' => params[:part] }
    @target = session[:save]['target']
    @order = session[:save]['order']
    @date = session[:save]['date']
    @part = session[:save]['part']
    if @order == 'd'
      @list = Movie.order_by_date_desc(@date).page(params[:page])
    else
      @list = Movie.order_by_date(@date).page(params[:page])
    end
    session[:page] = {'first' => 0, 'last' => @list.size }
  end
  
  def select
    if(params[:select_order])
      session[:save]['order'] = params[:select_order]
    end
    if(params[:datepicker])
      session[:save]['date'] = params[:datepicker]
    end
    if(params[:part])
      session[:save]['part'] = params[:part]
    end
    redirect_to :action => "show", :order => session[:save]['order'],
    :target => session[:save]['target'], :date => session[:save]['date'],
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




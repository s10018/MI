# -*- coding: utf-8 -*-

class MoviesController < ApplicationController
  helper_method :get_title, :get_info

  $scale = 0.25
  $width = 640
  $height = 480
  $row = 3
  $column = 6
  $select_order_list = [['降順','a'],
                        ['昇順','d']]
  $max_camera = 14
  
  def index
    redirect_to :action => "show", :target => 'date', :date => '2012-09-20', :order => 'd'
  end
  
  def show
    session[:save] = {'target' => params[:target], 'date' => params[:date], 'order' => params[:order] }
    @target = session[:save]['target']
    @order = session[:save]['order']
    @date = session[:save]['date']
    @list = get_list(get_all_list(), @target, @date, @order)
    session[:page] = {'first' => 0, 'last' => @list.size }
  end

  def page
  end
  
  def get_list(alist, target, key, order)
    p key
    list = []
    alist.each do |movie|
      info = get_info(movie, target)
      if(compare(key,info))
        list << movie
      end
    end
    if order == 'd'
      return list.reverse
    else
      return list
    end
  end
  
  def compare(a,b)
    alist = a.split("-")
    blist = b.split("-")
    short = []; long = [];
    if(alist.size <= blist.size)
      short = alist; long = blist
    else
      short = blist; long = alist
    end
    short.each_index do |i|
      if(short[i] != long[i])
        return false
      end
    end
    return true
  end
  
  def get_all_list
    list = []
    Dir::glob("public/images/**/*.jpg").each {|f|
      f[0..5] = ""
      list << f
    }
    return list;
  end
  
  def get_info(filename,type="all")
    re = /(\d\d\d\d-\d\d-\d\d-\d\d-\d\d)-(\d\d)/
    list = filename.scan(re)
    if(type == "all")
      return {'date' => list[0][0], 'camera' => list[0][1].to_i }
    elsif(type == 'date')
      return list[0][0]
    elsif(type == 'camera')
      return list[0][1].to_i
    end
  end

  def get_title(target)
    info = get_info(target)
    return "<p>CAMERA: #{info['camera']}</p><p>DATE:#{info['date']}</p>"
  end
  
  def select
    order = params[:select_order]
    session[:save]['order'] = order
    redirect_to :action => "show", :order => order, :target => session[:save]['target'], :date => session[:save]['date']
  end
  
  def create_num_list(list)
    numlist = []
    list.each_index do |i|
      numlist << [list[i][0], i]
    end
    return numlist
  end
end




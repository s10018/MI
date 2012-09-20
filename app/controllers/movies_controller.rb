# -*- coding: utf-8 -*-

class MoviesController < ApplicationController
  helper_method :get_title

  $scale = 0.25
  $width = 640
  $height = 480
  $row = 6
  $select_order_list = [['カメラ番号降順','camera_a'],
                        ['カメラ番号昇順','camera_d'],
                        ['日付昇順','date_a'],
                        ['日付降順','date_d']]
  
  def index()
    redirect_to :action => "show", :mode => 'detail', :target => 'camera', :num => 0, :order => 'a'
  end

  def show()
    @mode = params[:mode]
    @target = params[:target]
    @order = params[:order]
    @num = params[:num].to_i
    @group_list = list_group(get_path, @target, @order)
    @select_num_list = create_num_list(@group_list)
  end
  
  def create_num_list(list)
    numlist = []
    list.each_index do |i|
      numlist << [list[i][0], i]
    end
    return numlist
  end
  
  def change
    t = params[:select_order].scan(/(\w+)_(\w)/)
    n = params[:select_num].to_i
    mode = 'detail'
    redirect_to :action => "show", :target => t[0][0], :order => t[0][1], :num => n, :mode => mode
  end

  def get_path
    list = []
    Dir::glob("public/images/**/*.jpg").each {|f|
      f[0..5] = ""
      list << f
    }
    return list;
  end
  
  def get_info(filename)
    re = /(\d\d\d\d-\d\d-\d\d-\d\d-\d\d)-(\d\d)/
    list = filename.scan(re)
    return {'date' => list[0][0], 'camera' => list[0][1].to_i }
  end

  def get_title(target)
    info = get_info(target)
    return "<p>CAMERA: #{info['camera']}</p><p>DATE:#{info['date']}</p>"
  end
  
  def list_group(list, target, order)
    glist = Hash.new
    list.each do |movie|
      info = get_info(movie)
      if glist.has_key?(info[target])
        glist[info[target]] << movie
      else
        glist[info[target]] = [movie]
      end
    end
    if order == 'd'
      return glist.sort{|a, b| b[0] <=> a[0] }
    else
      return glist.sort{|a, b| a[0] <=> b[0] }
    end
  end
end




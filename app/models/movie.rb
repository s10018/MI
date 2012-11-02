# -*- coding: utf-8 -*-
class Movie < ActiveRecord::Base
  attr_accessible :camera, :date, :path
  paginates_per 18
  scope :order_by_date, lambda {|date,order|
    if(order == 'a')
      where("date like ?","#{date}%").order("date")
    else
      where("date like ?","#{date}%").order("date desc")
    end
  }
  scope :date_range, lambda {|from, to|
    where("date between ? and ?", from, to)
  }
  scope :part, lambda {|date, part, order|
    part_time = [ ['08-30','08-50'], ['08-50','10-30'], ['10-30','12-00'],
                  ['12-00','13-00'], ['13-00','14-40'], ['14-40','16-20'],
                  ['16-20','17-50'], ['17-50','20-00'] ]
    if(order == 'a')
      where("date between ? and ?", "#{date}-#{part_time[part][0]}", "#{date}-#{part_time[part][1]}").order("date")
    else
      where("date between ? and ?", "#{date}-#{part_time[part][0]}", "#{date}-#{part_time[part][1]}").order("date desc")
    end
      
  }
  
  def self.get_list(target, key, order, alist = get_all_list)
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

  def self.get_info(filename,type="all")
    re = /(\d\d\d\d-\d\d-\d\d-\d\d-\d\d)-(\d\d)/
    list = filename.scan(re)
    if(type == "all")
      return {'date' => list[0][0], 'camera' => list[0][1] }
    elsif(type == 'date')
      return list[0][0]
    elsif(type == 'camera')
      return list[0][1]
    end
  end
  
  def self.compare(a,b)
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
  
  def self.get_all_list
    list = []
    Dir::glob("public/images/**/*.jpg").each do |f|
      f[0..5] = "" # publicを除く
      list << f
    end
    return list;
  end

  def self.all_update
    #delete_all
    all = get_all_list()
    all.each do |m|
      if(Movie.find(:all, :conditions=> "path = '#{m}'") == [])
        info = get_info(m)
        movie = new(:path => m, :camera => info['camera'], :date => info['date'])
        movie.save
      end
    end
  end
  
end

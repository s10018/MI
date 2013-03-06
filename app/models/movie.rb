# -*- coding: utf-8 -*-
class Movie < ActiveRecord::Base
  attr_accessible :camera, :date, :path
  acts_as_taggable_on :tags

  $camera_size = 16
  paginates_per $camera_size

  part_time = [ ['08-30','08-50'], ['08-50','10-30'], ['10-30','12-00'],
                ['12-00','13-00'], ['13-00','14-40'], ['14-40','16-20'],
                ['16-20','17-50'], ['17-50','20-00'] ]
  
  scope :order_by_date, lambda {|date, order|
    ord = order == 'a' ? 'date' : 'date desc'
    where("date like ?","#{date}%").order(ord)
  }

  scope :camera_date, lambda {|camera, date, order|
    ord = order == 'a' ? 'date' : 'date desc'
    where("camera like ?","#{camera}%").where("date like ?","#{date}%").order(ord)
  }

  scope :date_range, lambda {|from, to|
    where("date between ? and ?", from, to)
  }
  
  scope :part, lambda {|date, part, order|
    ord = order == 'a' ? 'date' : 'date desc'
    list = []
    part.each do |p|
      list.append("date between '#{date}-#{part_time[p.to_i][0]}' and '#{date}-#{part_time[p.to_i][1]}'")
    end
    ord = order == 'a' ? 'date' : 'date desc'
    where(list.join(" or ")).order("date").order("camera").order(ord)
  }
  
  scope :control, lambda {|c, date, part, order|
    dd = date.split(/-/)
    t = Time.mktime(dd[0],dd[1],dd[2])
    control = {
      "nm" => 4.week.ago(t), "nw" => 1.week.ago(t),
      "pm" => 4.week.since(t), "pw" => 1.week.since(t)
    }
    part(control[c].strftime("%Y-%m-%d"), part, order)
  }
  
  def self.get_list(target, key, order, alist = get_now_directory_list)
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
  
  def self.get_info(filename, type="all")
    re = /(\d\d\d\d-\d\d-\d\d-\d\d-\d\d)-(\d\d)/
    list = filename.scan(re)
    if(list == [])
      return false
    elsif(type == "all")
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
  
  def self.get_now_directory_list
    list = []
    Dir::glob("public/images/**/*.jpg").each do |f|
      f[0..5] = "" # publicを除く
      list << f
    end
    return list;
  end
  
  def self.get_dblist
    all = Movie.all
    list = all.map{|x| x.path}
    return list
  end
  
  def self.all_update
    all = Movie.get_now_directory_list()
    db = Movie.get_dblist()
    diff = all - db
    if(diff.size%$camera_size)
      for n in 0..(diff.size%$camera_size-1) do
        diff.pop
      end
    end
    diff.each do |m|
      info = get_info(m)
      if(info)
        movie = new(:path => m, :camera => info['camera'], :date => info['date'])
        movie.save
      end
    end
  end
  
end

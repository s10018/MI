# -*- coding: utf-8 -*-
class Movie < ActiveRecord::Base
  
  attr_accessible :camera, :date, :path
  acts_as_taggable_on :tags

  $camera_size = 16
  paginates_per $camera_size

  part_time = [ ['08-30','08-50'], ['08-50','10-30'], ['10-30','12-00'],
                ['12-00','13-00'], ['13-00','14-40'], ['14-40','16-20'],
                ['16-20','17-50'], ['17-50','20-00'] ]

  scope :date_range, lambda {|from, to|
    a_table = Movie.arel_table
    between = a_table[:date].gteq(from).and(a_table[:date].lt(to))
    where(between)
  }

  scope :range_date, lambda {|date, order|
    ord = order == 'a' ? 'date' : 'date desc'
    sp = date.split('-')
    d = Time.mktime(*sp)
    if sp.size == 3
      # the range is equal to a day
      date_range(d, 1.day.since(d)).order(ord)
    elsif sp.size == 2
      # the range is equal to a month
      date_range(d, 1.month.since(d)).order(ord)
    elsif sp.size == 1
      # the range is equal to a year
      date_range(d, 1.year.since(d)).order(ord)
    end
  }

  scope :camera_date, lambda {|camera, date, order|
    ord = order == 'a' ? 'date' : 'date desc'
    where("camera = ?", camera).order(ord)
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
    t = Time.mktime(*date.split(/-/))
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
      info = Movie.get_info(m)
      if(info)
        movie = new(:path => m,
                    :camera => info['camera'],
                    :date => info['date']+" "+info['time'].gsub('-',':'))
        movie.save
      end
    end
  end

  def get_date
    return self.date
  end
  
  def self.get_info(movie, type="all")
    re = /(\d\d\d\d-\d\d-\d\d)-(\d\d-\d\d)-(\d\d)/
    if movie.class == String
      list = movie.scan(re)
    elsif movie.class == Movie
      list = movie.path.scan(re)
    end
    if(type == "all")
      return {'date' => list[0][0], 'time' => list[0][1], 'camera' => list[0][2].to_i }
    elsif(type == 'date')
      return list[0][0]
    elsif(type == 'time')
      return list[0][1]
    elsif(type == 'camera')
      return list[0][2].to_i
    end
  end

end

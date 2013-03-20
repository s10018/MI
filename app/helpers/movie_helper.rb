# -*- coding: utf-8 -*-
module MovieHelper
  include ActsAsTaggableOn::TagsHelper

  def get_info(movie, type="all")
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
    
  def get_part(part)
    h = ['0時限目','1時限目','2時限目','昼休み','3時限目','4時限目','5時限目','6時限目']
    if(part.class == Fixnum)
      return h[part];
    elsif(part.class == Array)
      return part.collect{|x| h[x.to_i]}.join(" ")
    end
  end

  def cal_time(date,add)
    if add == 1
      return 1.minute.since(date).strftime("%H:%M")
    elsif add == -1
      return 1.minute.ago(date).strftime("%H:%M")
    end
  end
  
end







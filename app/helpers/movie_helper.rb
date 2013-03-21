# -*- coding: utf-8 -*-
module MovieHelper
  include ActsAsTaggableOn::TagsHelper

  def show_date(t)
    return t.strftime("%Y-%m-%d")
  end
  
  def get_info(movie, type="all")
    return Movie.get_info(movie,type)
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







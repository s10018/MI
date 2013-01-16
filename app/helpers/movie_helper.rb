# -*- coding: utf-8 -*-
module MovieHelper
  include ActsAsTaggableOn::TagsHelper
  
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
    return "<p>CAMERA: #{target.camera}</p><p>DATE:#{target.date}</p>"
  end
  
  def get_part(part)
    h = ['0時限目','1時限目','2時限目','昼休み','3時限目','4時限目','5時限目','6時限目']
    return h[part];
  end

end







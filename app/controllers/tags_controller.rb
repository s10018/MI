# -*- coding: utf-8 -*-

class TagsController < ApplicationController

  def add
    add_tag = params[:addtag]
    status = "error"
    sucess = ""
    if(add_tag != "")
      @movie = Movie.find(params[:id])
      @movie.tag_list << add_tag
      if(@movie.save)
        status = "success"
        success = "「#{add_tag}」を追加しました"
      end
    end
    @movie = Movie.find(params[:id])
    render :json => {
      :status => status,
      :success => success,
      :elem => "#tag_info#{@movie.id}",
      :tags => @movie.tag_list
    }
  end

end

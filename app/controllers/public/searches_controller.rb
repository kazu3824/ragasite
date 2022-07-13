class Public::SearchesController < ApplicationController
  def search_tag
    @tracks = Track.where(tag_id: params["track"]["tag_id"])
    render 'public/searches/index'
  end

  def search_keyword
    @tracks = Track.joins(:artist)
              .where("tracks.title like ? or tracks.description like ? or artists.name like ?",
              "%" + params["track"]["keyword"] + "%",
              "%" + params["track"]["keyword"] + "%",
              "%" + params["track"]["keyword"] + "%")
    render 'public/searches/index'
  end
end

class AddSmallAndLargeCoverArtDeleteUrlsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :small_cover_art, :string
    add_column :videos, :large_cover_art, :string
    remove_column :videos, :small_cover_url
    remove_column :videos, :large_cover_url
  end
end

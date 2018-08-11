class AddPhotoToTweet < ActiveRecord::Migration[5.1]
  def change
    add_column :tweets, :photo, :string
  end
end

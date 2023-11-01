class AddAndRemoveColumnFromMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :title, :string
    remove_column :movies, :name, :string
  end
end

class MigrateToViewable < ActiveRecord::Migration
  def change
    add_column :articles, :viewable_by_all, :integer, default: 0

    Article.where(published: true).each do |article|
      article.viewable_by_all = 2
      article.save
    end

    remove_column :articles, :published
    remove_column :movies_and_ideas, :published
    remove_column :footage, :published
  end
end

class CreatePosts < ActiveRecord::Migration[5.0]
    def up
        create_table :posts do |t|
            t.belongs_to :user, index: true
            t.integer :user_id
            t.string :username
            t.string :input
            t.string :title
        end
    end

    def down
        drop_table :posts
    end
end
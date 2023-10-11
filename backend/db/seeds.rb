# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

def create_data(model, func, count: 100)
    ids = []
    count.times do |i|
        begin
            r = model.create!(func.call(i))
            ids << r.id
        rescue => e
            Rails.logger.error("Error generating #{model.to_s}: #{e}")
        end
    end

    ids
end

user_data = lambda do |i|
    Faker::Internet.user('email', 'password').merge(username: "#{Faker::Internet.username(separators: [])}#{i}")
end

user_ids = create_data(User, user_data)

item_data = lambda do |_|
    {
        title: Faker::Commerce.product_name,
        description: Faker::Lorem.sentence,
        user_id: user_ids.sample
    }
end

item_ids = create_data(Item, item_data)

comment_data = lambda do |_|
    {
        body: Faker::Lorem.sentence(word_count: 20),
        user_id: user_ids.sample,
        item_id: item_ids.sample
    }
end

create_data(Comment, comment_data)
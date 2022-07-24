# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create(:email => 'test@com', :password => 'hoge123')

Tag.create(:name => 'レゲエ')
Tag.create(:name => 'ジャパニーズレゲエ')
Tag.create(:name => 'ルーツロックレゲエ')
Tag.create(:name => 'ダンスホール・レゲエ')
Tag.create(:name => 'ダブ')
Tag.create(:name => 'ラバダブ')
Tag.create(:name => 'ロックステディ')
Tag.create(:name => '海で聴きたい')
Tag.create(:name => 'ドライブ')
Tag.create(:name => '落ち着きたい時')
Tag.create(:name => '気分を上げたい時')
Tag.create(:name => '落ち込んだ時')
Tag.create(:name => '集中したい時')


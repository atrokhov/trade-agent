# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or create!d alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create!([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create!(name: 'Luke', movie: movies.first)

admin = User.create!(username: "admin", name: "Arthur", phone: "+996559582111", email: "aatrokhov@gmail.com", password: "admin123", password_confirmation: "admin123", role: :admin)
moderator = User.create!(username:"moder", name: "Eds", phone: "+996559582222", email: "eds@gmail.com", password: "moderator", password_confirmation: "moderator", role: :moderator)

client_user = User.create!(username:"client", name: "Janybek", phone: "+996559582112", email: "user1@gmail.com", password: "qwerty123", password_confirmation: "qwerty123", role: :client)
provider_user_1 = User.create!(username:"provider1", name: "Kairat", phone: "+996559582113", email: "user2@gmail.com", password: "password", password_confirmation: "password", role: :provider)
provider_user_2 = User.create!(username:"provider2", name: "Sajackat", phone: "+996559582115", email: "user3@gmail.com", password: "password", password_confirmation: "password", role: :provider)
staff_user_1 = User.create!(username:"staff1", name: "Adis", phone: "+996559582114", email: "user4@gmail.com", password: "password123", password_confirmation: "password123", role: :courier)
staff_user_2 = User.create!(username:"staff2", name: "Vika", phone: "+996559582116", email: "user5@gmail.com", password: "password123", password_confirmation: "password123", role: :manager)
staff_user_3 = User.create!(username:"staff3", name: "Sasha", phone: "+996559582117", email: "user6@gmail.com", password: "password123", password_confirmation: "password123", role: :courier)
staff_user_4 = User.create!(username:"staff4", name: "Andrej", phone: "+996559582118", email: "user7@gmail.com", password: "password123", password_confirmation: "password123", role: :manager)

category_1 = Category.create!(name: "Ликёро-водочные изделия", description: "Ликёро-водочные изделия")
category_2 = Category.create!(name: "Мыло-моющие изделия", description: "Мыло-моющие изделия")

provider_1 = Provider.create!(name: "ЗАО 'ХренТам и ко'", description: "Низкое качество - по высоким ценам. Стоймость звонка: 100$ в секунду", address: "Охренеть как далеко, без Сусанина не найдешь", phone: "+996312778899", user_id: provider_user_1.id)
provider_2 = Provider.create!(name: "ЗАО 'АвтоРИТЕТ'", description: "Не купишь у нас, найдем и убьем!", address: "Смотри 2GIS, придурок!", phone: "+996312666666", user_id: provider_user_2.id)

subcategory_1 = Subcategory.create!(name: "Водка", description: "Водка", category_id: category_1.id)
subcategory_2 = Subcategory.create!(name: "Пиво", description: "Пиво", category_id: category_1.id)
subcategory_3 = Subcategory.create!(name: "Мыло", description: "Мыло", category_id: category_2.id)
subcategory_4 = Subcategory.create!(name: "Шампунь", description: "Шампунь", category_id: category_2.id)

client = Client.create!(user_id: client_user.id, date_of_birth: Time.now, client_type: :private_person, city: "Bishkek")
client.avatar.attach(io: File.open(Rails.root.join('app', 'assets', '1.png')), filename: '1.png', content_type: 'image/png')
client.patent.attach(io: File.open(Rails.root.join('app', 'assets', '1.png')), filename: '1.png', content_type: 'image/png')
client.passport.attach(io: File.open(Rails.root.join('app', 'assets', '1.png')), filename: '1.png', content_type: 'image/png')
client.certificate.attach(io: File.open(Rails.root.join('app', 'assets', '1.png')), filename: '1.png', content_type: 'image/png')

client_address_1 = Shop.create!(client_id: client.id, name: "ГопСтоп", address: "Мы подошли из-за угла")
client_address_2 = Shop.create!(client_id: client.id, name: "ХренТам", address: "Где-то")

blog = Blog.create!(name: "Анекдот", body: "В эстонский магазин заходит русский пенсионер и на ломаном эстонском языке просит взвесить 250 грамм сыра. Продавщица долго слушает, наконец отвечает по-русски: 'Гавриттье па-рюсски, я па-аннимаю'. Пенсионер отвечает: 'Мы 50 лет слушали ваш русский. Теперь вы послушайте наш эстонский'")

banner = Banner.create!(name: "СКИДКИ!!!", link: "https://google.com")

staff_courier_1 = Staff.create!(role: "Курьер", user_id: staff_user_1.id, provider_id: provider_1.id)
staff_courier_2 = Staff.create!(role: "Курьер", user_id: staff_user_3.id, provider_id: provider_2.id)

staff_manager_1 = Staff.create!(role: "Менеджер", user_id: staff_user_2.id, provider_id: provider_1.id)
staff_manager_2 = Staff.create!(role: "Менеджер", user_id: staff_user_4.id, provider_id: provider_2.id)

district = District.create!(provider_id: provider_1.id, clients: [client.id])

trade_agent_user = User.create!(username: "Trade", password: "password", role: :trade_agent)
trade_agent = Staff.create!(role: :trade_agent, user_id: trade_agent_user.id, provider_id: provider_1.id, district_id: district.id)


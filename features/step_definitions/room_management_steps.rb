# language: ru
@all
@ruby

Допустим(/^пользователь находится на странице со списком комнат$/) do
  visit rooms_path
end

Если(/^пользователь вводит название новой комнаты "([^"]*)"$/) do |room_name|
  fill_in 'room_name', with: room_name
end

Если(/^пользователь отправляет форму создания комнаты$/) do
  click_button 'Save'
end

То(/^на странице должна быть видна новая комната "([^"]*)"$/) do |room_name|
  expect(page).to have_content(room_name)
end

То(/^количество комнат не должно увеличиться после попытки создания комнаты без названия$/) do
  initial_room_count = Room.count
  expect(Room.count).to eq(initial_room_count)
end

Допустим(/^создана комната с названием "([^"]*)"$/) do |room_name|
  @room = Room.create(name: room_name, is_private: false)
  visit root_path
end


Тогда(/^на странице должна быть видна информация о комнате "([^"]*)"$/) do |room_name|
  expect(page).to have_content(room_name)
end

Тогда(/^пользователь может видеть сообщения в этой комнате$/) do
  expect(page).to have_css('#messages')
end

Тогда(/^пользователь находится на странице этой комнаты "([^"]*)"$/) do |room_name|
  click_link 'Тестовая комната'
  expect(page).to have_css('.custom-link', text: room_name)
end

Тогда(/^я выбираю другого пользователя для создания частной комнаты "([^"]*)"$/) do |user_name|
  click_link user_name
end
# language: ru
@all
@ruby

Допустим(/^существует пользователь с именем "(.*?)" и email "(.*?)"$/) do |username, email|
  User.create(username: username, email: email, password: 'qwerty123')
end

Когда(/^я иду по адресу "(.*?)"$/) do |path|
  visit path
end

И(/^я заполняю "(.*?)" поле значением "(.*?)"$/) do |field, value|
  fill_in field, with: value
end

И(/^я нажимаю на кнопку "(.*?)"$/) do |button|
  click_button button
end

И(/^я нажимаю кнопку "(.*?)"$/) do |button|
  click_button button, visible: false
end

Тогда(/^я должен увидеть сообщение "(.*?)"$/) do |message|
  expect(page).to have_content(message)
end

И(/^я должен быть перенаправлен на корневую страницу$/) do
  expect(current_path).to eq(root_path)
end

Тогда(/^я должен увидеть сообщение об успешном выходе$/) do
  expect(page).to have_content("Signed out successfully")
end

Тогда(/^я должен увидеть сообщение об ошибке "(.*?)"$/) do |error_message|
  expect(page).to have_content(error_message)
end

Допустим(/^я авторизован как пользователь$/) do
  @current_user = User.create(username: 'current_user', email: 'current_user@example.com', password: 'qwerty123')
  visit new_user_session_path
  fill_in 'user_email', with: @current_user.email
  fill_in 'user_password', with: 'qwerty123'
  click_button 'Log in'
end

То(/^существует несколько пользователей, включая меня$/) do
  User.create(username: 'user1', email: 'user1@example.com', password: 'password123')
  User.create(username: 'user2', email: 'user2@example.com', password: 'password123')
end

Когда(/^я просматриваю список пользователей$/) do
  visit root_path
end

То(/^я должен увидеть список пользователей, исключая себя$/) do
  expect(page).to have_content('user1')
  expect(page).to have_content('user2')

  expect(page).not_to have_content(@current_user.username)
end
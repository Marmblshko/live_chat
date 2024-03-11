# language: ru
@all
@ruby

Когда(/^пользователь отправляет сообщение "([^"]*)" в эту комнату$/) do |message_text|
  @initial_message_count = Message.count
  fill_in "message_message_text", with: message_text
  click_button "Send"
end

Тогда(/^сообщение должно быть успешно создано$/) do
  expect(Message.count).to eq(@initial_message_count + 1)
end

Тогда(/^все пользователи в комнате должны увидеть сообщение "([^"]*)"$/) do |expected_message|
  expect(@room.messages.pluck(:message_text)).to include(expected_message)
end

Тогда(/^двое пользователя в частной комнате должны увидеть сообщение "([^"]*)"$/) do |expected_message|
  visit current_path
  expect(page).to have_content(expected_message)
end

Когда(/^пользователь отправляет пустое сообщение в эту комнату$/) do
  @initial_message_count = Message.count
  fill_in "message_message_text", with: ''
  click_button "Send"
end

Тогда(/^количество сообщений не должно увеличиться после попытки создания пустого сообщения$/) do
  expect(Message.count).to eq(@initial_message_count)
end

Когда(/^пользователь отправляет очень длинное сообщение в эту комнату$/) do
  @initial_message_count = Message.count
  @long_message_text = "a" * 255
  fill_in "message_message_text", with: @long_message_text
  click_button "Send"
end
users_data = [
  { username: 'test_user_1', email: 'user1@example.com', password: 'qwerty123' },
  { username: 'test_user_2', email: 'user2@example.com', password: 'qwerty123' },
  { username: 'test_user_3', email: 'user3@example.com', password: 'qwerty123' },
  { username: 'test_user_4', email: 'user4@example.com', password: 'qwerty123' },
  { username: 'test_user_5', email: 'user5@example.com', password: 'qwerty123' }
]

users = User.create(users_data)

public_rooms_data = (1..5).map { |n| { name: "Public Room #{n}", is_private: false } }
private_rooms_data = [
  { name: 'private_1_2', is_private: true },
  { name: 'private_2_3', is_private: true },
  { name: 'private_3_4', is_private: true }
]

public_rooms = Room.create(public_rooms_data)
private_rooms = Room.create(private_rooms_data)

public_members_data = users.map { |user| { user: user, room: public_rooms.first } }
private_members_data = [
  { user: users[0], room: private_rooms[0] },
  { user: users[1], room: private_rooms[0] },
  { user: users[2], room: private_rooms[1] },
  { user: users[3], room: private_rooms[1] },
  { user: users[4], room: private_rooms[2] }
]

Member.create(public_members_data + private_members_data)

public_rooms.each do |room|
  users.each do |user|
    Message.create(user: user, room: room, message_text: "Hi from #{user.username} in #{room.name} :)")
  end
end

private_messages_data = [
  { user: users[0], room: private_rooms[0], message_text: 'Private message from user_1 to user_2 :)' },
  { user: users[1], room: private_rooms[0], message_text: 'Private reply from user_2 to user_1 :)' },
  { user: users[2], room: private_rooms[1], message_text: 'Private message from user_3 to user_4 :)' },
  { user: users[3], room: private_rooms[1], message_text: 'Private reply from user_4 to user_3 :)' },
  { user: users[4], room: private_rooms[2], message_text: 'Private message from user_5 to user_1 :)' },
  { user: users[0], room: private_rooms[2], message_text: 'Private reply from user_1 to user_5 :)' }
]
2.times do |n|
  Message.create(private_messages_data)
end
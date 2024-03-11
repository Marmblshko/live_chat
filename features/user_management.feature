# language: ru
@all
@ruby

Функционал: Управление пользователями

  Сценарий: Регистрация нового пользователя
    Когда я иду по адресу "/users/sign_up"
    И я заполняю "user_username" поле значением "test_user"
    И я заполняю "user_email" поле значением "user1@example.com"
    И я заполняю "user_password" поле значением "qwerty123"
    И я заполняю "user_password_confirmation" поле значением "qwerty123"
    И я нажимаю на кнопку "Sign up"
    Тогда я должен увидеть сообщение "Welcome! You have signed up successfully"

  Сценарий: Вход зарегистрированного пользователя
    Пусть существует пользователь с именем "test_user" и email "user1@example.com"
    Когда я иду по адресу "/users/sign_in"
    И я заполняю "user_email" поле значением "user1@example.com"
    И я заполняю "user_password" поле значением "qwerty123"
    И я нажимаю на кнопку "Log in"
    Тогда я должен увидеть сообщение "Signed in successfully"
    И я должен быть перенаправлен на корневую страницу

  Сценарий: Выход пользователя
    Пусть я авторизован как пользователь
    И я нажимаю кнопку "Logout"
    Тогда я должен увидеть сообщение об успешном выходе
    И я должен быть перенаправлен на корневую страницу

  Сценарий: Пользователь с пустым именем
    Когда я иду по адресу "/users/sign_up"
    И я заполняю "user_email" поле значением "user1@example.com"
    И я заполняю "user_password" поле значением "qwerty123"
    И я заполняю "user_password_confirmation" поле значением "qwerty123"
    И я нажимаю на кнопку "Sign up"
    Тогда я должен увидеть сообщение "Username can't be blank"

  Сценарий: Пользователь с существующим именем
    Пусть существует пользователь с именем "test_user" и email "user2@example.com"
    Когда я иду по адресу "/users/sign_up"
    И я заполняю "user_username" поле значением "test_user"
    И я заполняю "user_email" поле значением "user1@example.com"
    И я заполняю "user_password" поле значением "qwerty123"
    И я заполняю "user_password_confirmation" поле значением "qwerty123"
    И я нажимаю на кнопку "Sign up"
    Тогда я должен увидеть сообщение "Username has already been taken"

  Сценарий: Пользователь с коротким паролем
    Когда я иду по адресу "/users/sign_up"
    И я заполняю "user_username" поле значением "test_user"
    И я заполняю "user_email" поле значением "user1@example.com"
    И я заполняю "user_password" поле значением "123"
    И я заполняю "user_password_confirmation" поле значением "123"
    И я нажимаю на кнопку "Sign up"
    Тогда я должен увидеть сообщение об ошибке "Password is too short (minimum is 6 characters)"

  Сценарий: Пользователь с разными паролями
    Когда я иду по адресу "/users/sign_up"
    И я заполняю "user_username" поле значением "test_user"
    И я заполняю "user_email" поле значением "user1@example.com"
    И я заполняю "user_password" поле значением "qwerty123"
    И я заполняю "user_password_confirmation" поле значением "different_password"
    И я нажимаю на кнопку "Sign up"
    Тогда я должен увидеть сообщение об ошибке "Password confirmation doesn't match Password"

  Сценарий: Список пользователей, исключая текущего пользователя
    Пусть существует несколько пользователей, включая меня
    Пусть я авторизован как пользователь
    Когда я просматриваю список пользователей
    Тогда я должен увидеть список пользователей, исключая себя
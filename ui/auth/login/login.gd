extends Control

@onready var login_edit: LineEdit = $login_vbox/login_edit
@onready var password_edit: LineEdit = $login_vbox/password_edit

var regex: RegEx = RegEx.new()

signal login_pressed(login, password, username)

func _ready() -> void:
	regex.compile('.+\\@.+\\.[a-z][a-z]+')

func attempt_login() -> void:
	if login_edit.text.is_empty():
		print('Enter username or email to log in')
		return
	if password_edit.text.is_empty():
		print('Enter password to log in')
		return
		
	if regex.search(login_edit.text) != null:
		login_pressed.emit(login_edit.text, password_edit.text, "")
	else:
		login_pressed.emit("", password_edit.text, login_edit.text)

func _on_login_btn_pressed() -> void:
	attempt_login()

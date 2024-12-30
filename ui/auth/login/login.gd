extends Control

@onready var login_edit: LineEdit = $login_vbox/login_edit
@onready var password_edit: LineEdit = $login_vbox/password_edit

func attempt_login() -> void:
	if login_edit.text.is_empty():
		print('Enter username or email to log in')
		return
	if password_edit.text.is_empty():
		print('Enter password to log in')
		return

func _on_login_btn_pressed() -> void:
	attempt_login()

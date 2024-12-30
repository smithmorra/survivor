extends Control

@onready var username_edit: LineEdit = $register_vbox/username_edit
@onready var email_edit: LineEdit = $register_vbox/email_edit
@onready var password_edit: LineEdit = $register_vbox/password_edit
@onready var password_repeat_edit: LineEdit = $register_vbox/password_repeat_edit

signal register_pressed(email, username, password)

func _process(delta: float) -> void:
	pass

func check_is_empty() -> bool:
	if username_edit.text.is_empty():
		print("Username cannot be empty")
		return false
	elif email_edit.text.is_empty():
		print('Email cannot be empty')
		return false
	elif password_edit.text.is_empty() or password_repeat_edit.text.is_empty():
		print('Password cannot be empty')
		return false
	
	return true
	
func attempt_register() -> void:
	if not check_is_empty():
		return

	if not username_edit.is_valid:
		print('Username must contain from 3 to 12 characters')
		return
	elif not email_edit.is_valid:
		print('The email address is not valid')
		return
	elif not password_edit.is_valid:
		print("The password should be at least 8 characters long")
		return
	elif not password_repeat_edit.is_valid:
		print("Passwords do not match")
		return
	
	register_pressed.emit(email_edit.text, password_edit.text, username_edit.text)

func _on_register_btn_pressed() -> void:
	attempt_register()

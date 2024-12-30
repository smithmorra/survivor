extends LineEdit

@onready var password_edit: LineEdit = $"../password_edit"

var is_valid: bool

func _validate(password: String) -> void:
	if password_edit.text == password:
		is_valid = true
	else:
		is_valid = false
	return 

func _on_text_changed(new_text: String) -> void:
	_validate(new_text)

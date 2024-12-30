extends LineEdit

var is_valid: bool

func _validate(password: String) -> void:
	if password.length() >= 8:
		is_valid = true
	else:
		is_valid = false

func _on_text_changed(new_text: String) -> void:
	_validate(new_text)

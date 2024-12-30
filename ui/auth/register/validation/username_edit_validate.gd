extends LineEdit

var is_valid: bool

func _validate(username: String) -> bool:
	if username.length() >= 3 and username.length() <= 12: 
		is_valid = true
	else: 
		is_valid = false
	return is_valid

func _on_text_changed(new_text: String) -> void:
	_validate(new_text)

extends LineEdit

var is_valid: bool

func _validate(text: String) -> bool:
	if text.length() >= 3 and text.length() <= 12: 
		is_valid = true
	else: 
		is_valid = false
	return is_valid

func _on_text_changed(new_text: String) -> void:
	_validate(new_text)

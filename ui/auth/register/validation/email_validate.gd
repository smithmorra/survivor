extends LineEdit

var regex := RegEx.new()

var is_valid: bool

func _ready() -> void:
	regex.compile('.+\\@.+\\.[a-z][a-z]+')

func _validate(email_text: String) -> void:
	if regex.search(email_text) != null:
		is_valid = true
	else:
		is_valid = false

func _on_text_changed(new_text: String) -> void:	
	_validate(new_text)

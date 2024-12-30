class_name Authenticator 
extends RefCounted

var session: NakamaSession
var _client: NakamaClient
var _exception_handler: ExceptionHandler

func _init(client: NakamaClient, exception_handler: ExceptionHandler) -> void:
	_client = client
	_exception_handler = exception_handler
	
func login_async(email: String, password: String, username: String) -> int:
	print(email + " " + username)
	var new_session: NakamaSession = await _client.authenticate_email_async(
		email, password, username, false
	)
	var parsed_result: int = _exception_handler.parse_exception(new_session)
	if parsed_result == OK:
		session = new_session
	return parsed_result

func register_async(email: String, password: String, username: String) -> int:
	var new_session:  NakamaSession = await _client.authenticate_email_async(
		email, password, username, true
	)
	
	var parsed_result: int = _exception_handler.parse_exception(new_session)
	if parsed_result == OK:
		session = new_session
	else:
		_exception_handler.error_message = _exception_handler.error_message.replace(
			"Username", "Email"
		)
	return parsed_result

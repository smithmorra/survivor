extends Control

@onready var parent: TabContainer = $"./auth_tab_container"

const max_request_attempts: int = 3
var _server_request_attempts: int = 0

func join_world_async() -> int:
	var result: int = await ServerConnection.connect_to_server_async()
		
	if result == OK:
		pass
		
	return result

func authenticate_user_async(login: String, password: String, username: String) -> int:
	var result: int = -1
	while result != OK:
		if _server_request_attempts == max_request_attempts:
			break
		_server_request_attempts += 1
		result = await ServerConnection.login_async(login, password, username)
		
	if result == OK:
		await join_world_async()
	else:
		print(result, " ",ServerConnection.get_error_message())
	_server_request_attempts = 0
	return result

func _on_register_pressed(email: String, password: String, username: String) -> void:
	#parent.process_mode = Node.PROCESS_MODE_DISABLED
	var result: int = await ServerConnection.register_async(email, password, username)
	if result == OK:
		await authenticate_user_async(email, password, username)
	else:
		print(result, " ", ServerConnection.get_error_message())


func _on_login_login_pressed(login: String, password: String, username: String) -> void:
	await authenticate_user_async(login, password, username)

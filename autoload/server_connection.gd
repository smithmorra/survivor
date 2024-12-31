extends Node

const server_key: String = 'defaultkey'
const nakama_host: String = '85.159.229.44'
const nakama_port: int = 7350
const nakama_scheme: String = 'http'

var error_message: String = ""

var _client: NakamaClient = Nakama.create_client(server_key, nakama_host, nakama_port, nakama_scheme)
var _socket: NakamaSocket

var _room_id: String
var _channel_id: String

var presences: Dictionary

var _expection_handler: ExceptionHandler = ExceptionHandler.new()
var _authenticator: Authenticator = Authenticator.new(_client, _expection_handler)

func join_room_async() -> int:
	if not _socket:
		error_message = "Server not connected"
		return ERR_UNAVAILABLE
		
	if not _room_id:
		var room: NakamaAPI.ApiRpc = await _client.rpc_async(_authenticator.session, "get_room_id")
		var parsed_result: int = _expection_handler.parse_exception(room)
		
		if parsed_result != OK:
			return parsed_result
		
		_room_id = room.payload
	
	var match_join_result: NakamaRTAPI.Match = await _socket.join_match_async(_room_id)
	var parsed_result: int = _expection_handler.parse_exception(match_join_result)

	if parsed_result == OK:
		for presence in match_join_result.presences:
			presences[presence.user_id] = presence

		var chat_join_result: NakamaRTAPI.Channel = await _socket.join_chat_async("Survivor", NakamaSocket.ChannelType.Room, false, false)
		parsed_result = _expection_handler.parse_exception(chat_join_result)

		if parsed_result == OK:
			_channel_id = chat_join_result.id
	
	return parsed_result

func connect_to_server_async():
	_socket = Nakama.create_socket_from(_client)
	
	var result: NakamaAsyncResult = await _socket.connect_async(_authenticator.session)
	var parsed_result: int = _expection_handler.parse_exception(result)
	
	if parsed_result == OK:
		_socket.connect("connected", _on_socket_connected)
		_socket.connect("connected", _on_socket_closed)
		_socket.connect("connection_error", _on_socket_connection_error)
		_socket.connect("received_error", _on_socket_received_error)
		_socket.connect("received_match_presence", _on_socket_received_match_presence)
		_socket.connect("received_match_state", _on_socket_received_match_state)
		_socket.connect("received_channel_message", _on_socket_received_channel_message)

	return parsed_result
	
func _on_socket_connected() -> void:
	print("Socket connected")
	
func _on_socket_closed() -> void:
	_socket = null
	
func _on_socket_connection_error() -> void:
	pass
	
func _on_socket_received_error() -> void:
	pass

func _on_socket_received_match_presence() -> void:
	pass

func _on_socket_received_match_state() -> void:
	pass
	
func _on_socket_received_channel_message() -> void:
	pass

func login_async(email: String, password: String, username: String) -> int:
	var result: int = await _authenticator.login_async(email, password, username)
	return result

func register_async(email: String, password: String, username: String) -> int:
	var result: int = await _authenticator.register_async(email, password, username)
	return result

func get_error_message() -> String:
	return _expection_handler.error_message
	

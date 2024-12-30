extends Node

const server_key: String = 'defaultkey'
const nakama_host: String = '85.159.229.44'
const nakama_port: int = 7350
const nakama_scheme: String = 'http'

var error_message: String = ""

var _client: NakamaClient = Nakama.create_client(server_key, nakama_host, nakama_port, nakama_scheme)
var _socket: NakamaSocket

var _expection_handler: ExceptionHandler = ExceptionHandler.new()
var _authenticator: Authenticator = Authenticator.new(_client, _expection_handler)

func login_async(email: String, password: String, username: String) -> int:
	var result: int = await _authenticator.login_async(email, password, username)
	return result

func register_async(email: String, password: String, username: String) -> int:
	var result: int = await _authenticator.register_async(email, password, username)
	return result

func get_error_message() -> String:
	return _expection_handler.error_message
	

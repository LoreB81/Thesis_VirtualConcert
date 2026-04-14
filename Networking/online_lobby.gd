extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = "7000"
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 20

var players = {}


var player_info = {"name": "Name"}

var players_loaded = 0



func _ready():
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func join_game(address:String = "", port:String =""):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	if port.is_empty() or !port.is_valid_int() or port.to_int()<0:
		port= PORT
	var error = peer.create_client(address, port.to_int())
	if error:
		print(error)
	multiplayer.multiplayer_peer = peer


func create_game(port:String = ""):
	var peer = ENetMultiplayerPeer.new()
	if port.is_empty() or !port.is_valid_int() or port.to_int()<0:
		port= PORT
	var error = peer.create_server(port.to_int(), MAX_CONNECTIONS)
	if error != OK:
		print("Errore creazione server: ", error)
		if error == ERR_ALREADY_IN_USE:
			print("La porta è già occupata!")
		elif error == ERR_CANT_CREATE:
			print("Il sistema impedisce la creazione del socket")
	else:
		multiplayer.multiplayer_peer = peer
		print("Server avviato correttamente sulla porta ", port)
	multiplayer.multiplayer_peer = peer

	players[1] = player_info
	player_connected.emit(1, player_info)


func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()


# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)


# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	pass


# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)


func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func _on_connected_fail():
	remove_multiplayer_peer()


func _on_server_disconnected():
	remove_multiplayer_peer()
	players.clear()
	server_disconnected.emit()

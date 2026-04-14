extends Node3D

@onready var mappa: Node3D = $Mappa

const SPAWN_ZONE := 5.0

func _ready() -> void:
	$MultiplayerSpawner.set_multiplayer_authority(1)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if multiplayer.is_server():
		add_player(1)
	else:
		notify_server_ready.rpc_id(1)
@rpc("authority", "call_local", "reliable")
func start_soundtrack(stream: String, time: float = 0.0):
	print("sinc audio")
	mappa.get_node(stream).play(time)

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func add_player(id):
	var player = preload("res://Components/Player/mp_player.tscn").instantiate()
	#salta i duplicati
	if $Players.has_node(str(id)):
		return
	player.name = str(id)
	print("Sto aggiungendo il player ", id)
	var pos = Vector2.from_angle(randf()*2*PI)
	player.position = Vector3(pos.x * SPAWN_ZONE * randf(), 0, pos.y * SPAWN_ZONE * randf())
	$Players.add_child(player, true)
@rpc("any_peer", "call_local", "reliable")
func notify_server_ready():
	var peer_id = multiplayer.get_remote_sender_id()
	print("Il Client ", peer_id, " è pronto. Spawno il suo player...")
	add_player(peer_id)
	if multiplayer.is_server():
		for x in mappa.audiostreams:
			start_soundtrack.rpc_id(peer_id, x, mappa.get_audio_pos(x))
	

func _on_multiplayer_spawner_spawned(node: Node) -> void:
	print("Spawnato ",node)

extends Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MultiplayerSpawner.set_multiplayer_authority(1)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if multiplayer.is_server():
		add_player(1)
	else:
		notify_server_ready.rpc_id(1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# Se premiamo INVIO sul server dopo che il client è connesso
	if event.is_action_pressed("ui_accept") and multiplayer.is_server():
		print("Forzo spawn Host...")
		add_player(1)
func add_player(id):
	var player = preload("res://Components/Player/mp_player.tscn").instantiate()
	#salta i duplicati
	if $Players.has_node(str(id)):
		return
	player.name = str(id)
	print("Sto aggiungendo il player ", id)
	$Players.add_child(player, true)
	player.set_move(id)

@rpc("any_peer", "call_local", "reliable")
func notify_server_ready():
	var peer_id = multiplayer.get_remote_sender_id()
	print("Il Client ", peer_id, " è pronto. Spawno il suo player...")
	add_player(peer_id)

func _on_multiplayer_spawner_spawned(node: Node) -> void:
	print("Spawnato ",node)

extends Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(add_player)
		print(OnlineLobby.players)
		for id in OnlineLobby.players:
			add_player(id)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func add_player(id):
	OnlineLobby.player_loaded.rpc_id(id)
	var player = preload("res://Components/Player/player.tscn").instantiate()
	self.add_child(player)
	player.position.y+=1
	player.set_active(true)

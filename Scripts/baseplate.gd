extends Node3D

var index = 0
var players:Array
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	players = [%MainSubViewPort, %Playerview]
	players[0].set_active(true)

func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		players[index].pass_input(event)
	if event.is_action_pressed("az_switch"):
		players[index].set_active(false)
		index = index_next(index, players)
		players[index].set_active(true)
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func index_next(index: int, array: Array)-> int:
	if index < array.size()-1:
		index+=1
	else: 
		index = 0
	return index

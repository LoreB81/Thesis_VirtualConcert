extends Node
class_name ControllerComponent

@onready var c: MovementComponent = get_parent()
@onready var a = c.player
func input(event)->Vector2:
	if event is InputEventJoypadMotion and event.axis>1:
		var horizontal = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var vertical = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		if abs(horizontal) < 0.2: 
			horizontal = 0
		if abs(vertical) < 0.2:
			vertical = 0
		return Vector2(horizontal, vertical)
	return Vector2.ZERO

func move()->Vector2:
	return Input.get_vector("js_sinistra", "js_destra", "js_avanti", "js_dietro",0.2)

extends Node
class_name KeyBoard_Component

@onready var giocatore: CharacterBody3D = get_parent().get_parent()
@onready var c: MovementComponent = get_parent()


func input(event)-> Vector2:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return event.relative
	else:
		return Vector2.ZERO
func move()-> Vector2:
	return Input.get_vector("mv_sinistra", "mv_destra", "mv_avanti", "mv_dietro")

extends Node
class_name ControllerComponent

@onready var c: MovementComponent = get_parent()
@onready var a = c.player
var visual_moving = Vector2.ZERO
func input(event):
	if event is InputEventJoypadMotion and event.axis>1:
		if event.axis == 2:
			visual_moving.y = -event.axis_value*0.1
		elif event.axis == 3:
			visual_moving.x = -event.axis_value*0.1

func move():
	if visual_moving != Vector2.ZERO:
		c.modello.rotate_y(visual_moving.y)
		c.pgc.rotate_x(visual_moving.x)
	c.pgc.rotation.x = clamp(c.pgc.rotation.x, deg_to_rad(-70), deg_to_rad(70))
	c.pgc.rotation.y = clamp(c.pgc.rotation.y, deg_to_rad(0), deg_to_rad(0))
	c.pgc.rotation.z = clamp(c.pgc.rotation.z, deg_to_rad(0), deg_to_rad(0))
	var input_dir = Input.get_vector("js_sinistra", "js_destra", "js_avanti", "js_dietro")
	var direction = (c.modello.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		a.velocity.x = direction.x * c.locspeed
		a.velocity.z = direction.z * c.locspeed
	else:
		a.velocity.x = move_toward(a.velocity.x, 0, c.locspeed)
		a.velocity.z = move_toward(a.velocity.z, 0, c.locspeed)

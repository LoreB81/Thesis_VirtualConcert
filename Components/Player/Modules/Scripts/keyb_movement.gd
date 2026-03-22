extends Node
class_name KeyBoard_Component

@onready var c:MovementComponent = get_parent()
@onready var a = c.player
func input(event):
	if event is InputEventMouseMotion:
		c.modello.rotate_y(-event.relative.x*0.01)
		c.pgc.rotate_x(-event.relative.y*0.01)
		c.pgc.rotation.x = clamp(c.pgc.rotation.x, deg_to_rad(-70), deg_to_rad(70))
		c.pgc.rotation.y = clamp(c.pgc.rotation.y, deg_to_rad(0), deg_to_rad(0))
		c.pgc.rotation.z = clamp(c.pgc.rotation.z, deg_to_rad(0), deg_to_rad(0))
func move():
	var input_dir = Input.get_vector("mv_sinistra", "mv_destra", "mv_avanti", "mv_dietro")
	var direction = (c.modello.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		a.velocity.x = direction.x * c.locspeed
		a.velocity.z = direction.z * c.locspeed
	else:
		a.velocity.x = move_toward(a.velocity.x, 0, c.locspeed)
		a.velocity.z = move_toward(a.velocity.z, 0, c.locspeed)

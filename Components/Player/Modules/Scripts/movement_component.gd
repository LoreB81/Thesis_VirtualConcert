extends Node
class_name MovementComponent

@onready var player = get_parent()
# costanti di movimento
const SPEED = 5.0
const SPRINT = 10.0
const MAX_STEP_HEIGHT = 0.4
const step_speed = 0.6
@onready var is_sprinting = false
@onready var is_reset = true
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF
@export var locspeed: float
@onready var collo = %Collo
@onready var pgc = %CameraPOV
@onready var vista = %VistaInt
@onready var modello = %Modello

var interact_timeout=false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func input(event):
	if event.is_action_pressed("az_inter"):
		if vista.is_colliding():
			var ogg :Object= vista.get_collider()
			if ogg is StaticBody3D:
				ogg = ogg.get_parent()
			if ogg.has_method("interaz") and not interact_timeout:
				player.interagisci(ogg)
	if event.is_action_pressed("az_sprint"):
		is_sprinting = true
	if event.is_action_released("az_sprint"):
		is_sprinting = false
	for x in get_children():
		var rel = x.input(event)
		modello.rotate_y(-rel.x*0.01)
		pgc.rotate_x(-rel.y*0.01)
		pgc.rotation.x = clamp(pgc.rotation.x, deg_to_rad(-70), deg_to_rad(70))
		pgc.rotation.y = clamp(pgc.rotation.y, deg_to_rad(0), deg_to_rad(0))
		pgc.rotation.z = clamp(pgc.rotation.z, deg_to_rad(0), deg_to_rad(0))

	
func move(delta):
		# Add the gravity.
	if is_sprinting:
		locspeed = SPRINT
	else:
		locspeed = SPEED
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	if get_child_count()>0:
		for x in get_children():
			var input_dir= x.move()
			var direction = (player.modello.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction:
				player.velocity.x = direction.x * locspeed
				player.velocity.z = direction.z * locspeed
			else:
				player.velocity.x = move_toward(player.velocity.x, 0, locspeed)
				player.velocity.z = move_toward(player.velocity.z, 0, locspeed)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, locspeed)
		player.velocity.z = move_toward(player.velocity.z, 0, locspeed)
	player.move_and_slide()
	
func interagisci(obj):
	if obj.has_signal("finished"):
		interact_timeout = true
		obj.finished.connect(restore_interaction)
	obj.interaz()
	
func restore_interaction():
	interact_timeout = false

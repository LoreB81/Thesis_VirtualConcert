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


func _snap_down_to_stairs_check():
	var did_snap = false
	if not player.is_on_floor() and player.velocity.y <= 0 and (_last_frame_was_on_floor or _snapped_to_stairs_last_frame) and %StairsBelowRayCast3D.is_colliding():
		var body_test_result = PhysicsTestMotionResult3D.new()
		var params = PhysicsTestMotionParameters3D.new()
		var max_step_down = -0.5
		params.from = self.global_transform
		params.motion = Vector3(0,max_step_down,0)
		if PhysicsServer3D.body_test_motion(player.get_rid(), params, body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			player.apply_floor_snap()
			did_snap = true

	_last_frame_was_on_floor = player.is_on_floor()
	_snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if not player.is_on_floor() and not _snapped_to_stairs_last_frame: return false
	# Don't snap stairs if trying to jump, also no need to check for stairs ahead if not moving
	if player.velocity.y > 0 or (player.velocity * Vector3(1,0,1)).length() == 0: return false
	var expected_move_motion = player.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance = player.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	# Run a body_test_motion slightly above the pos we expect to move to, towards the floor.
	#  We give some clearance above to ensure there's ample room for the player.
	#  If it hits a step <= MAX_STEP_HEIGHT, we can teleport the player on top of the step
	#  along with their intended motion forward.
	var down_check_result = KinematicCollision3D.new()
	if (player.test_move(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - player.global_position).y
		# Note I put the step_height <= 0.01 in just because I noticed it prevented some physics glitchiness
		# 0.02 was found with trial and error. Too much and sometimes get stuck on a stair. Too little and can jitter if running into a ceiling.
		# The normal character controller (both jolt & default) seems to be able to handled steps up of 0.1 anyway
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01: return false
		%StairsAheadRayCast3D.global_position = down_check_result.get_position() + Vector3(0,MAX_STEP_HEIGHT,0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			player.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			player.apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false

func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle
	
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
	if not _snap_up_stairs_check(delta):
		player.move_and_slide()
		_snap_down_to_stairs_check()
func interagisci(obj):
	if obj.has_signal("finished"):
		interact_timeout = true
		obj.finished.connect(restore_interaction)
	obj.interaz()
	
func restore_interaction():
	interact_timeout = false

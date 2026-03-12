extends CharacterBody3D


const SPEED = 5.0
const SPRINT = 10.0
const MAX_STEP_HEIGHT = 0.4
const step_speed = 0.6

var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var collo = %Collo
@onready var pgc = %CameraPOV
@onready var vista = %VistaInt
@onready var is_sprinting = false
@onready var is_reset = true
@onready var lblint = %lblcomando
@onready var modello = %Modello
@onready var schand: PackedScene

var interact_timeout=false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	pass
	#if vista.is_colliding():
		#var ogg = vista.get_collider()
		#is_reset = false
		#if ogg!= null and ogg.get_parent().has_method("interaz") or ogg.has_method("interaz"):
			#lblint.text = "Press E to interact"
		#else:
			#lblint.text = ""
	#else:
		#if !is_reset:
			#lblint.text = ""
			#is_reset = true

func _unhandled_input(event):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		modello.rotate_y(-event.relative.x*0.01)
		pgc.rotate_x(-event.relative.y*0.01)
		pgc.rotation.x = clamp(pgc.rotation.x, deg_to_rad(-70), deg_to_rad(70))
		pgc.rotation.y = clamp(pgc.rotation.y, deg_to_rad(0), deg_to_rad(0))
		pgc.rotation.z = clamp(pgc.rotation.z, deg_to_rad(0), deg_to_rad(0))
	if event.is_action_pressed("az_inter"):
		if vista.is_colliding():
			var ogg :Object= vista.get_collider()
			if ogg is StaticBody3D:
				ogg = ogg.get_parent()
			if ogg.has_method("interaz") and not interact_timeout:
				interagisci(ogg)
	if event.is_action_pressed("az_sprint"):
		print("sprinting")
		is_sprinting = true
	if event.is_action_released("az_sprint"):
		print("walking")
		is_sprinting = false		
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	# Add the gravity.
	var locspeed 
	if is_sprinting:
		locspeed = SPRINT
	else:
		locspeed = SPEED
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("mv_sinistra", "mv_destra", "mv_avanti", "mv_dietro")
	var direction = (modello.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * locspeed
		velocity.z = direction.z * locspeed
	else:
		velocity.x = move_toward(velocity.x, 0, locspeed)
		velocity.z = move_toward(velocity.z, 0, locspeed)
	if not _snap_up_stairs_check(delta):
		move_and_slide()
		_snap_down_to_stairs_check()

func _snap_down_to_stairs_check():
	var did_snap = false
	if not is_on_floor() and velocity.y <= 0 and (_last_frame_was_on_floor or _snapped_to_stairs_last_frame) and %StairsBelowRayCast3D.is_colliding():
		var body_test_result = PhysicsTestMotionResult3D.new()
		var params = PhysicsTestMotionParameters3D.new()
		var max_step_down = -0.5
		params.from = self.global_transform
		params.motion = Vector3(0,max_step_down,0)
		if PhysicsServer3D.body_test_motion(self.get_rid(), params, body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true

	_last_frame_was_on_floor = is_on_floor()
	_snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false
	# Don't snap stairs if trying to jump, also no need to check for stairs ahead if not moving
	if self.velocity.y > 0 or (self.velocity * Vector3(1,0,1)).length() == 0: return false
	var expected_move_motion = self.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	# Run a body_test_motion slightly above the pos we expect to move to, towards the floor.
	#  We give some clearance above to ensure there's ample room for the player.
	#  If it hits a step <= MAX_STEP_HEIGHT, we can teleport the player on top of the step
	#  along with their intended motion forward.
	var down_check_result = KinematicCollision3D.new()
	if (self.test_move(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		# Note I put the step_height <= 0.01 in just because I noticed it prevented some physics glitchiness
		# 0.02 was found with trial and error. Too much and sometimes get stuck on a stair. Too little and can jitter if running into a ceiling.
		# The normal character controller (both jolt & default) seems to be able to handled steps up of 0.1 anyway
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01: return false
		%StairsAheadRayCast3D.global_position = down_check_result.get_position() + Vector3(0,MAX_STEP_HEIGHT,0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false

func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

func interagisci(obj):
	if obj.has_signal("finished"):
		interact_timeout = true
		obj.finished.connect(restore_interaction)
	obj.interaz()
	

func restore_interaction():
	interact_timeout = false

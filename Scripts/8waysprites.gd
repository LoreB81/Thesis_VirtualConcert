extends Node3D
class_name EightWayAnimatedSprite
@export var sprite: AnimatedSprite3D
@export var action = ""
@export var EightWayMode:= true
@export var front_ref: Node= self
@export var flip = false
@export var symmetric = true
func _process(delta: float) -> void:
	if EightWayMode: orientate()

func orientate() -> void:
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return
	#direzione rispetto alla telecamera
	var dirc = camera.global_position - global_position
	var view_angle = atan2(dirc.x, dirc.z)
	var fwd = -front_ref.global_transform.basis.z
	if flip: fwd*=-1
	var obj_angle = atan2(fwd.x, fwd.z)
	var angle = view_angle - obj_angle
	angle = fposmod(angle, TAU) # Normalizza tra 0 e 2PI
	var step = TAU / 8.0
	var index = int(round(angle / step)) % 8
	_select_animation_with_flip(index,symmetric)

func _select_animation_with_flip(index: int, symmetric = true):
	match index:
		0: sprite.play(str("B",action)); if symmetric: sprite.flip_h = false
		1: sprite.play(str("BL",action)); if symmetric: sprite.flip_h = false
		2: sprite.play(str("L",action)); if symmetric: sprite.flip_h = false
		3: sprite.play(str("FL",action)); if symmetric: sprite.flip_h = false
		4: sprite.play(str("F",action)); if symmetric: sprite.flip_h = false
		5: if symmetric: 
			sprite.play(str("FL",action)) 
			sprite.flip_h = true 
		else: sprite.play(str("FR",action));
		6: if symmetric: 
			sprite.play(str("L",action)) 
			sprite.flip_h = true 
		else: sprite.play(str("R",action));
		7: if symmetric: 
			sprite.play(str("BL",action)) 
			sprite.flip_h = true 
		else: sprite.play(str("BR",action));
		
func set_action(act: String)->void:
	action = act
func get_action()->String:
	return action

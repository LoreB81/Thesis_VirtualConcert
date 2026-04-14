extends Node3D
@onready var sprite: AnimatedSprite3D = $Animated_Sprite


func _process(delta: float) -> void:
	orientate()

func orientate() -> void:
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return
	var cam_fwd = -camera.global_transform.basis.z
	var cam_angle = atan2(cam_fwd.x, cam_fwd.z)
	var obj_fwd = -global_transform.basis.z
	var obj_angle = atan2(obj_fwd.x, obj_fwd.z)
	var angle = cam_angle - obj_angle
	angle = fposmod(angle, TAU)
	var step = TAU / 8.0
	var index = int(round(angle / step)) % 8
	_select_animation_with_flip(index)

func _select_animation_with_flip(index: int):
	match index:
		0: sprite.play("B"); sprite.flip_h = false
		1: sprite.play("BL"); sprite.flip_h = false
		2: sprite.play("L"); sprite.flip_h = false
		3: sprite.play("FL"); sprite.flip_h = false
		4: sprite.play("F"); sprite.flip_h = false
		5: sprite.play("FL"); sprite.flip_h = true
		6: sprite.play("L"); sprite.flip_h = true
		7: sprite.play("BL"); sprite.flip_h = true

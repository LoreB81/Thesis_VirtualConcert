extends AnimatedSprite3D


func _process(delta: float) -> void:
	orientate()

func orientate() -> void:
	var camera = get_viewport().get_camera_3d()
	if camera ==null:
		return
	var dir= ["F","FL","L","BL","B","BR","R"]
	var c_fwd = -camera.global_transform.basis.z #Camera forward
	var fwd = self.global_transform.basis.z # Sprite Forward
	var left = self.global_transform.basis.x # Sprite Forward
	var f_dot = fwd.dot(c_fwd) # The dot product of the sprite forward.
	var l_dot = left.dot(c_fwd) # The dot product of the sprite left.
	if f_dot < -0.8:
		self.play("B")
	elif f_dot > 0.8:
		self.play("F")
	else:
		self.flip_h = l_dot > 0
		if abs(f_dot) < 0.5:
			self.play("L")
		elif f_dot < 0.25:
			self.play("BL")
		else:
			self.play("FL")

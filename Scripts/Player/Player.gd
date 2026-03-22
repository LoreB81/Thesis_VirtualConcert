extends CharacterBody3D

#variabili per muovere i giocatori
@onready var Movement : MovementComponent = %Movement_component

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
	%Movement_component.input(event)
func _physics_process(delta):
	# ferma gli utenti non attivi
	%Movement_component.move(delta)

func set_active(x:bool, controller: bool = false):
	%CameraPOV.current = x
	if x:
		if controller:
			Movement.add_child(ControllerComponent.new())
		else:
			Movement.add_child(KeyBoard_Component.new())
	else:
		for a in Movement.get_children():
			a.queue_free()

func get_movement()->MovementComponent:
	return Movement

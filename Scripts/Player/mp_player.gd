extends CharacterBody3D


#variabili per muovere i giocatori
@onready var Movement : MovementComponent = %Movement_component
@onready var modello: MeshInstance3D = %Modello
@onready var camera_pov: Camera3D = %CameraPOV
@onready var input: MultiplayerSynchronizer = $InputSync

func _ready() -> void:
	self.name = str(multiplayer.get_unique_id())
	set_multiplayer_authority(self.name.to_int())
	if is_multiplayer_authority():
		camera_pov.make_current()
		set_process(true)
		set_physics_process(true)
	else:
		camera_pov.current = false
		set_process(false)
		set_physics_process(false)
		$CollisionShape3D.disabled = true

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
	Movement.input(event)


func _physics_process(delta):
	# ferma gli utenti non attivi
	Movement.move(delta)

# aggiunge il componente di movimento alla tastiera per muovere il player
func set_active(x:bool, controller: bool = false):
	if get_multiplayer_authority() == int(self.name):
		%CameraPOV.current = x
	if x:
		var temp
		if controller:
			temp = ControllerComponent.new()
		else:
			temp = KeyBoard_Component.new()
		temp.set_multiplayer_authority(int(self.name))
		Movement.add_child(temp)
	else:
		for a in Movement.get_children():
			a.queue_free()

func get_movement()->MovementComponent:
	return Movement
	
func set_move(id:int):
	var x = KeyBoard_Component.new()
	x.set_multiplayer_authority(id)
	Movement.add_child(x)

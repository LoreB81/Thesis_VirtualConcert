extends CharacterBody3D


#variabili per muovere i giocatori
@onready var Movement : MovementComponent = %Movement_component
@onready var modello: MeshInstance3D = %Modello
@onready var camera_pov: Camera3D = %CameraPOV
@onready var input: MultiplayerSynchronizer = $InputSync

func _ready() -> void:
	self.position.y+=1
	set_multiplayer_authority(name.to_int())
	var a =get_multiplayer_authority()
	var b = multiplayer.get_unique_id()
	print(a,"-",b)
	if a == b:
		set_process(true)
		camera_pov.make_current()
	else:
		set_process(false)
		camera_pov.current = false
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
	if is_multiplayer_authority():
		Movement.input(event)


func _physics_process(delta):
	if is_multiplayer_authority():
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

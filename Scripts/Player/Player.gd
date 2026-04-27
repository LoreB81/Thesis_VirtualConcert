extends CharacterBody3D

#Giocatore locale

#variabili per muovere i giocatori

@onready var Movement : MovementComponent = %Movement_component
@onready var modello: MeshInstance3D = %Modello
@onready var camera_pov: Camera3D = %CameraPOV
@onready var nametag: Label3D = $Nametag

func _ready() -> void:
	pass

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

## Abilità o meno il componente di movimento che può essere [ControllerComponent] se [param controller] è [code]true[/code] altrimenti [KeyboardComponent]
func set_active(x:bool, controller: bool = false):
	%CameraPOV.current = x
	if x:
		var temp
		if controller:
			temp = ControllerComponent.new()
		else:
			temp = KeyBoardComponent.new()
		Movement.add_child(temp)
	else:
		for a in Movement.get_children():
			a.queue_free()

func get_movement()->MovementComponent:
	return Movement
	

func set_nickname(name:String)->void:
	nametag.text = name

extends CharacterBody3D

#Giocatore fatto apposta per il multiplayer
const SPAWN_ZONE := 5.0
#variabili per muovere i giocatori
@onready var Movement : MovementComponent = %Movement_component
#@onready var modello: MeshInstance3D = %Modello
@onready var camera_pov: Camera3D = %CameraPOV
# Input per il multiplayer
@onready var input: MultiplayerSynchronizer = $InputSync
# Nametag per il multiplayer
@onready var nametag: Label3D = $Nametag

# Da a Cesare quel che è di Cesare
func _ready() -> void:
	set_multiplayer_authority(name.to_int())
	var a =get_multiplayer_authority()
	var b = multiplayer.get_unique_id()
	print(a,"-",b)
	if a == b:
		set_move(b)
		set_process(true)
		get_viewport().get_node("CrossAir").visible = true
		camera_pov.make_current()
		nametag.text = OnlineLobby.local_name
		var pos = Vector2.from_angle(randf()*2*PI)
		self.position = Vector3(pos.x * SPAWN_ZONE * randf(), 1, pos.y * SPAWN_ZONE * randf())
		if OnlineLobby.tutorial:
			get_viewport().add_child(load("res://Menus/tutorial_menu.tscn").instantiate())
	else:
		set_process(false)
		camera_pov.current = false
		%Nametag.show()
func _process(_delta):
	pass

func _unhandled_input(event):
	if is_multiplayer_authority():
		Movement.input(event, true)


func _physics_process(delta):
	if is_multiplayer_authority():
		Movement.move(delta, true)
		if %VistaInt.is_colliding():
			var ogg :Object= %VistaInt.get_collider()
			if ogg is StaticBody3D:
				ogg = ogg.get_parent()
			if ogg.has_method("interaz") and ogg.txtinter !=null:
				get_viewport().get_node("InteractionText").text = ogg.txtinter
		else:
			get_viewport().get_node("InteractionText").text = ""

## Abilità o meno il componente di movimento che può essere [ControllerComponent] se [param controller] è [code]true[/code] altrimenti [KeyboardComponent]
func set_active(x:bool, controller: bool = false):
	if get_multiplayer_authority() == int(self.name):
		%CameraPOV.current = x
	if x:
		var temp
		if controller:
			temp = ControllerComponent.new()
		else:
			temp = KeyBoardComponent.new()
		temp.set_multiplayer_authority(int(self.name))
		Movement.add_child(temp)
	else:
		for a in Movement.get_children():
			a.queue_free()

## Getter del [MovementComponent]
func get_movement()->MovementComponent:
	return Movement
	
## Abilità un [KeyBoardComponent]
func set_move(id:int):
	var x = KeyBoardComponent.new()
	x.set_multiplayer_authority(id)
	input.add_child(x)

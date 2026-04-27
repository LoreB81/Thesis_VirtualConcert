extends CharacterBody3D

#Giocatore fatto apposta per il multiplayer

#variabili per muovere i giocatori
@onready var Movement : MovementComponent = %Movement_component
@onready var modello: MeshInstance3D = %Modello
@onready var camera_pov: Camera3D = %CameraPOV
# Input per il multiplayer
@onready var input: MultiplayerSynchronizer = $InputSync
# Nametag per il multiplayer
@onready var nametag: Label3D = $Nametag

# Da a Cesare quel che è di Cesare
func _ready() -> void:
	self.position.y+=1
	set_multiplayer_authority(name.to_int())
	var a =get_multiplayer_authority()
	var b = multiplayer.get_unique_id()
	print(a,"-",b)
	if a == b:
		set_move(b)
		set_process(true)
		camera_pov.make_current()
		nametag.text = OnlineLobby.local_name
	else:
		set_process(false)
		camera_pov.current = false
func _process(_delta):
	pass

func _unhandled_input(event):
	if is_multiplayer_authority():
		Movement.input(event, true)


func _physics_process(delta):
	if is_multiplayer_authority():
		Movement.move(delta, true)

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

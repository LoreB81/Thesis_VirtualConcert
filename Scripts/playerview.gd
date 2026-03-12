extends SubViewportContainer

@export var width = 1920
@export var height = 1080

func _ready() -> void:
	%SubViewport.size.x = width
	%SubViewport.size.y = height

func set_world3d(world: World3D):
	%SubViewport.world_3d = world

func set_active(b:bool):
	%Giocatore.active = b

func pass_input(event: InputEvent):
	%SubViewport.push_input(event)

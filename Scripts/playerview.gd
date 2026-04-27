extends SubViewportContainer

@export var width = 1920
@export var height = 1080

func _ready() -> void:
	%SubViewport.size.x = width
	%SubViewport.size.y = height

func set_world3d(world: World3D):
	%SubViewport.world_3d = world

func set_active(b:bool, controller: bool = false):
	var move = %Giocatore.get_movement()
	if b:
		if controller:
			%lbl_nplayer.add_theme_color_override("font_color", Color("Blue"))
			move.add_child(ControllerComponent.new())
		else:
			%lbl_nplayer.add_theme_color_override("font_color", Color("Red"))
			move.add_child(KeyBoardComponent.new())
	else:
		%lbl_nplayer.add_theme_color_override("font_color", Color("White"))
		for a in move.get_children():
			a.queue_free()

# getter e setter vari

func pass_input(event: InputEvent):
	%SubViewport.push_input(event)

func add_position(z: int):
	%Giocatore.position.z += z
	
func get_player_position()->Vector3:
	return %Giocatore.position

func change_lbl_text(a:int):
	%lbl_nplayer.text = str(a)

func change_lbl_size(a:float):
	%lbl_nplayer.add_theme_font_size_override("font_size", max(10, (%lbl_nplayer.get_theme_font_size("font_size")*a)))

func audio_debug()->String:
	return str(%SubViewport.audio_listener_enable_3d)

func get_character()-> CharacterBody3D:
	return %Giocatore

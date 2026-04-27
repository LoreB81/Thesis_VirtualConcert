extends Node3D
class_name EightWayAnimatedSprite
## Layer per il cambio di direzione di sprite per effetto simil 3D grazie a 8 decal che compongono i lati

## Sprite effettivo con animazioni
@export var sprite: AnimatedSprite3D

## Animazione da riprodurre, impostare con _ davanti
@export var action = ""

## Per attivare o disattivare la modalità 8Way rendendo questo nodo inutile 
@export var EightWayMode:= true

## Nodo che fare da riferimento per la direzione davanti dello sprite
@export var front_ref: Node= self
## Variabile per capire quando specchiare lo sprite
@export var flip = false

## Variabile per capire se specchiare lo sprite in caso questo fosse simmetrico, 
## usando quindi un solo sprite specchiato per il lato destro e sinistro
@export var symmetric = true
func _process(delta: float) -> void:
	if EightWayMode: orientate()

## Funzione per capire la posizione relativa della telecamera rispetto allo sprite
func orientate() -> void:
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return
	#direzione rispetto alla telecamera
	var dirc = camera.global_position - global_position
	var view_angle = atan2(dirc.x, dirc.z)
	var fwd = -front_ref.global_transform.basis.z
	if flip: fwd*=-1
	var obj_angle = atan2(fwd.x, fwd.z)
	var angle = view_angle - obj_angle
	angle = fposmod(angle, TAU) # Normalizza tra 0 e 2PI
	var step = TAU / 8.0
	var index = int(round(angle / step)) % 8
	_select_animation_with_flip(index,symmetric)

## Funzione per cambiare la direzione convertendo [param index] in direzione e [param symmetric] se si desidera 
## che il lato destro sia il sinistro ma specchiato
func _select_animation_with_flip(index: int, symmetric = true):
	match index:
		0: sprite.play(str("B",action)); if symmetric: sprite.flip_h = false
		1: sprite.play(str("BL",action)); if symmetric: sprite.flip_h = false
		2: sprite.play(str("L",action)); if symmetric: sprite.flip_h = false
		3: sprite.play(str("FL",action)); if symmetric: sprite.flip_h = false
		4: sprite.play(str("F",action)); if symmetric: sprite.flip_h = false
		5: if symmetric: 
			sprite.play(str("FL",action)) 
			sprite.flip_h = true 
		else: sprite.play(str("FR",action));
		6: if symmetric: 
			sprite.play(str("L",action)) 
			sprite.flip_h = true 
		else: sprite.play(str("R",action));
		7: if symmetric: 
			sprite.play(str("BL",action)) 
			sprite.flip_h = true 
		else: sprite.play(str("BR",action));
		
func set_action(act: String)->void:
	action = act
func get_action()->String:
	return action

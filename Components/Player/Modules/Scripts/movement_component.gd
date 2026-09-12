extends Node
class_name MovementComponent
## Componente di movimento che gestisce i vari tipi di input di movimento che può fare il giocatore

## Riferimento al giocatore
@onready var player = get_parent()
# costanti di movimento

const SPEED = 5.0
const SPRINT = 10.0
const MAX_STEP_HEIGHT = 0.4
const step_speed = 0.6
@onready var is_sprinting = false
@onready var is_reset = true
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF
@export var locspeed: float
# Elementi modificabili dal giocatore
@onready var collo = %Collo
@onready var pgc = %CameraPOV
@onready var vista = %VistaInt
@onready var modello = %Modello
@onready var inputs: MultiplayerSynchronizer = $"../InputSync"

## Indica l'ultimo grado di visuale mossa per gestire il movimento da controller
var visual_moving:= Vector2.ZERO

## Timeout per le interazioni
var interact_timeout=false

##Gravità del progetto
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


## Gestore degli input da [param event]. 
##Il parametro [param multi] serve per dire alla funzione di gestire i player multigiocatori visto che la loro struttura di movimento è diversa
func input(event, multi:bool = false):
	if event.is_action_pressed("az_sprint"):
		is_sprinting = true
	if event.is_action_released("az_sprint"):
		is_sprinting = false
	if not multi:
		if event.is_action_pressed("az_inter"):
			if vista.is_colliding():
				var ogg :Object= vista.get_collider()
				if ogg is StaticBody3D:
					ogg = ogg.get_parent()
				if ogg.has_method("interaz") and not interact_timeout:
					interagisci(ogg)
		for x in get_children():
			var rel = x.input(event)
			if x is KeyBoardComponent:
				player.rotate_y(-rel.x*0.01)
				pgc.rotate_x(-rel.y*0.01)
				pgc.rotation.x = clamp(pgc.rotation.x, deg_to_rad(-70), deg_to_rad(70))
				pgc.rotation.y = clamp(pgc.rotation.y, deg_to_rad(0), deg_to_rad(0))
				pgc.rotation.z = clamp(pgc.rotation.z, deg_to_rad(0), deg_to_rad(0))
			else:
				visual_moving = rel
	else:
		if event.is_action_pressed("az_inter"):
			if vista.is_colliding():
				var ogg :Object= vista.get_collider()
				if ogg is StaticBody3D:
					ogg = ogg.get_parent()
				if ogg.has_method("interaz") and not interact_timeout:
					interagisci(ogg)
		var rel = inputs.input(event)
		player.rotate_y(-rel.x*0.01)
		pgc.rotate_x(-rel.y*0.01)
		pgc.rotation.x = clamp(pgc.rotation.x, deg_to_rad(-70), deg_to_rad(70))
		pgc.rotation.y = clamp(pgc.rotation.y, deg_to_rad(0), deg_to_rad(0))
		pgc.rotation.z = clamp(pgc.rotation.z, deg_to_rad(0), deg_to_rad(0))

## Gestore del movimento. 
##Il parametro [param multi] serve per dire alla funzione di gestire i player multigiocatori visto che la loro struttura di movimento è diversa	
func move(delta, multi:bool = false):
		# Add the gravity.
	if is_sprinting:
		locspeed = SPRINT
	else:
		locspeed = SPEED
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	if not multi:
		if get_child_count()>0:
			for x in get_children():
				if x is ControllerComponent:
					if visual_moving != Vector2.ZERO:
						player.rotate_y(-visual_moving.x * delta * 3.0) 
						pgc.rotate_x(-visual_moving.y * delta * 3.0)
					pgc.rotation.x = clamp(pgc.rotation.x, deg_to_rad(-70), deg_to_rad(70))
					pgc.rotation.y = clamp(pgc.rotation.y, deg_to_rad(0), deg_to_rad(0))
					pgc.rotation.z = clamp(pgc.rotation.z, deg_to_rad(0), deg_to_rad(0))
				var input_dir= x.move()
				var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
				if direction:
					player.velocity.x = direction.x * locspeed
					player.velocity.z = direction.z * locspeed
				else:
					player.velocity.x = move_toward(player.velocity.x, 0, locspeed)
					player.velocity.z = move_toward(player.velocity.z, 0, locspeed)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, locspeed)
			player.velocity.z = move_toward(player.velocity.z, 0, locspeed)
	else:
		var input_dir= inputs.direction
		var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			player.velocity.x = direction.x * locspeed
			player.velocity.z = direction.z * locspeed
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, locspeed)
			player.velocity.z = move_toward(player.velocity.z, 0, locspeed)
	player.move_and_slide()
	
## Interagisce con l'oggeto di fronte
func interagisci(obj):
	if obj.has_signal("finished"):
		interact_timeout = true
		obj.finished.connect(restore_interaction)
	if not multiplayer.is_server():
		obj.interaz.rpc_id(1)
	else: obj.interaz()
	
## Ripristina il timeout dell'interazione
func restore_interaction():
	interact_timeout = false

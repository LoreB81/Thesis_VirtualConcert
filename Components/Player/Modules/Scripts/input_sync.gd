extends MultiplayerSynchronizer

# Serve a sincronizzare i movimenti di un host sul server

## Componente di movimento del player
@onready var movement_component: MovementComponent = %Movement_component

## Richiamo a self, per qualche ragione
@onready var input_sync: MultiplayerSynchronizer = $"."

## Vettore di direzione presa in input dall'Host 
@export var direction: Vector2

func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


func _physics_process(delta: float) -> void:
	# Inoltra l'evento di movimento al proprio componente di movimento figlio e lo passa a direction
	if get_child_count()==1:
		direction = get_child(0).move()
	else:
		direction = Vector2.ZERO

## Inoltra l'[param event] di input al proprio componente di movimento figlio e lo restituisce
func input(event)-> Vector2:
	if get_child_count()==1:
		return get_child(0).input(event)
	else:
		return Vector2.ZERO

extends MultiplayerSynchronizer
@onready var movement_component: MovementComponent = %Movement_component
@onready var input_sync: MultiplayerSynchronizer = $"."
@export var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


func _physics_process(delta: float) -> void:
	if get_child_count()==1:
		direction = get_child(0).move()
	else:
		direction = Vector2.ZERO

func input(event)-> Vector2:
	if get_child_count()==1:
		return get_child(0).input(event)
	else:
		return Vector2.ZERO

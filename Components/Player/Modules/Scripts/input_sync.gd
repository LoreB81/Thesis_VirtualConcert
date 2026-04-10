extends MultiplayerSynchronizer
@onready var movement_component: MovementComponent = %Movement_component
@onready var input_sync: MultiplayerSynchronizer = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


func _physics_process(delta: float) -> void:
	pass

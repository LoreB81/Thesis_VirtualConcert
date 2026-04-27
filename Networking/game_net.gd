extends Node
## Subviewport principale dell'istanza
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

# Aggiunge l'intero gioco principale al server
func _ready() -> void:
	if multiplayer.is_server():
		sub_viewport.add_child(preload("res://pto_p.tscn").instantiate())


func _process(delta: float) -> void:
	pass

extends Node
## Subviewport principale dell'istanza
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

# Aggiunge l'intero gioco principale al server
func _ready() -> void:
	if multiplayer.is_server():
		if OnlineLobby.mode!= null:
			if OnlineLobby.mode == OnlineLobby.Modes.PTP:
				sub_viewport.add_child(preload("res://pto_p.tscn").instantiate())
			elif OnlineLobby.mode == OnlineLobby.Modes.SERVER:
				sub_viewport.add_child(preload("res://Components/Server/server.tscn").instantiate())
			else: print("Errore: Non ci sono modalità selezionate valide")
		else: print("Errore: Non ci sono modalità selezionate valide")

func _process(delta: float) -> void:
	pass

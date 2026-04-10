extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_host_pressed() -> void:
	InfoPartita.is_host = true
	print(OnlineLobby.create_game())
	OnlineLobby.load_game("Networking/GameNet.tscn")

func _on_btn_connect_pressed() -> void:
	print(OnlineLobby.join_game())
	OnlineLobby.load_game("Networking/GameNet.tscn")

extends Control

@onready var portahost: LineEdit = $SubViewportContainer/SubViewport/Sfondo/btn_host/txt_portahost
@onready var ip: LineEdit = $SubViewportContainer/SubViewport/Sfondo/Connect/txt_ip
@onready var portaguest: LineEdit = $SubViewportContainer/SubViewport/Sfondo/Connect/txt_portaguest


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_host_pressed() -> void:
	InfoPartita.is_host = true
	OnlineLobby.create_game(portahost.text)
	OnlineLobby.load_game("Networking/GameNet.tscn")

func _on_btn_connect_pressed() -> void:
	OnlineLobby.join_game(ip.text, portaguest.text)
	OnlineLobby.load_game("Networking/GameNet.tscn")

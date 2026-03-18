extends Node3D

var index = 0
var players: Array
var n_players
var splitscreen = PlayerCount.get_splitscreen()
func _ready() -> void:
	# prende il count dei giocatori locali dall'autoload
	n_players = PlayerCount.get_playercount()
	if splitscreen:
		players = [%MainSubViewPort]
		# per ogni giocatore istanzia una schermata e la aggiunge alla grid box
		for i in n_players-1:
			var x = preload("res://playerview.tscn").instantiate()
			x.add_position((i+1)*3)
			x.change_lbl_text(i+2)
			%GridContainer.add_child(x)
			players.append(x)
		divide_screen(players)
	else:
		players = [%Giocatore]
		# per ogni giocatore istanzia una schermata e la aggiunge alla grid box
		for i in n_players-1:
			var x = preload("res://player.tscn").instantiate()
			x.position.z += (i+1)*3
			x.position.y = 2
			%SubViewport.add_child(x)
			players.append(x)
	#cattura il mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	players[0].set_active(true)

func _unhandled_input(event: InputEvent) -> void:
	# serve per passare l'input che il mouse è stato mosso alla viewport corrispondente perché altrimenti non riceve l'input del mouse
	if splitscreen and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		players[index].pass_input(event)
	if event.is_action_pressed("az_switch"):
		players[index].set_active(false)
		index = index_next(index, players)
		players[index].set_active(true)
		if not splitscreen:
			%MainSubViewPort.change_lbl_text(index+1)
	if event.is_action_pressed("az_switch_back"):
		players[index].set_active(false)
		index = index_back(index, players)
		players[index].set_active(true)
		if not splitscreen:
			%MainSubViewPort.change_lbl_text(index+1)
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# serve per imitare una lista circolare
func index_next(index: int, array: Array)-> int:
	if index < array.size()-1:
		index+=1
	else: 
		index = 0
	return index

func index_back(index: int, array: Array)-> int:
	if index !=0 :
		index-=1
	else: 
		index = array.size()-1
	return index
# divide lo schermo in base a quanti giocatori sono presenti
func divide_screen(players: Array):
	var sqrtsize = sqrt(players.size())
	var size
	if sqrtsize == floor(sqrtsize):
		size = sqrtsize
	else:
		size = floor(sqrtsize)+1
	%GridContainer.columns = size
	var nw = DisplayServer.window_get_size().x/ size
	var nh = DisplayServer.window_get_size().y/ floor(sqrtsize)
	for x in players:
		x.change_lbl_size(nw/DisplayServer.window_get_size().x)
		x.width = nw
		x.height = nh

extends Node

var playercount = 1
var splitscreen = false
var controller = false
var is_host = false

func changecount(num:int):
	if num> 1:
		playercount = num
	else: playercount = 1

func get_playercount()->int:
	return playercount

func set_splitscreen(x : bool):
	splitscreen = x

func get_splitscreen()->bool:
	return splitscreen

func set_controller(x: bool):
	controller = x

func get_controller()->bool:
	return controller

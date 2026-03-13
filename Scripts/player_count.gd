extends Node

var playercount = 1

func changecount(num:int):
	if num> 1:
		playercount = num
	else: playercount = 1

func get_playercount()->int:
	return playercount

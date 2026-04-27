extends Node
## Componente per gestire il movimento da controller
class_name KeyBoardComponent

## Ritorna il movimento fatto da mouse dell'[param event]
func input(event)-> Vector2:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return event.relative
	else:
		return Vector2.ZERO

## Ritorna il movimento da tastiera 
func move()-> Vector2:
	return Input.get_vector("mv_sinistra", "mv_destra", "mv_avanti", "mv_dietro")

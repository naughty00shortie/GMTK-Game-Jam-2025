extends Node2D
signal jam_is_pumped

var player_near := false
const max_size := 6.0

func pump_up():
	if scale.x < max_size:
		scale += Vector2(0.5,0.5)
	else:
		emit_signal("jam_is_pumped")


func _ready():
	scale=Vector2(1,1)

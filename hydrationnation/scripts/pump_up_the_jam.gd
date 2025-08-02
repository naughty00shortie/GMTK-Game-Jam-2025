extends Node2D

var player_near := false
const max_size := 6.0

func pump_up():
	if scale.x < max_size:
		scale += Vector2(0.5,0.5)

func _ready():
	scale=Vector2(1,1)

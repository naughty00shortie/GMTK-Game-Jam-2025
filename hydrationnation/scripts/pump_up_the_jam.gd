extends Node2D
var x:=1.0
var y:=1.0
var factor:=0.5

var player_near := false

func pump_up():
	x += factor
	y += factor
	scale = Vector2(x,y)

func _ready():
	scale=Vector2(1,1)

func _process(delta):
	if player_near and Input.is_action_just_pressed("ui_accept"):
		scale += Vector2(0.5,0.5)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(player_near)
	# if body.name == "Player":
	player_near=true
	print(player_near)


func _on_area_2d_body_exited(body: Node2D) -> void:
	print(player_near)
	# if body.name == "Player":
	player_near=false
	print(player_near)

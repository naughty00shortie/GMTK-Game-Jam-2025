extends Node2D
signal pumped

@onready var animator = $AnimatedSprite2D
var player_near := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_near and Input.is_action_just_pressed("ui_accept"):
		animator.play("pump")
		emit_signal("pumped")
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_near=true

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_near=false

extends Area2D

class_name Door

@export var destination_level:String
# @export var spawn_position:Vector2
# @export var spawn_position = "up"
# @onready var spawn = $spawn


func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file(destination_level)
	

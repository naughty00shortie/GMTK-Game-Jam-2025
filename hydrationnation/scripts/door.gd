extends Area2D

class_name Door

@export var destination_level:String
@export var destination_door:String
# @export var spawn_position:Vector2
@export var spawn_position = "up"
@onready var spawn = $spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# func _on_body_entered(body:Node2D) -> void:
	# if body is Player:
	
	# pass # Replace with function body.

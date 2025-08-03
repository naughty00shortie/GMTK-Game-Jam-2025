extends Area2D

@export var item_name = ""

func _ready():
	body_entered.connect(_on_body_entered)
	if GlobalGameRunner.get_item_state(item_name):
		queue_free()  

func _on_body_entered(body):
	if body is Player:
		GlobalGameRunner.set_item_state(item_name, true)
		queue_free()
		print(item_name + " picked up!")

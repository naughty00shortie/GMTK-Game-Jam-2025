extends CharacterBody2D

@export var speed := 50

func _ready():
	print("yeet")



func _physics_process(_delta: float) -> void:
	
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	velocity = direction * speed
	move_and_slide()

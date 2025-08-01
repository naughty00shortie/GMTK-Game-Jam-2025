extends CharacterBody2D

@export var speed := 50
@export var maxHealth := 100
@export var health := 100
@export var attackDamage := 10
@export var attackCooldown := 1


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
	if Input.is_action_just_pressed("attack"):
		attack()

	velocity = direction * speed
	move_and_slide()

func takeDamage(damage: int):
	pass

func attack():
	pass

func die():
	pass

extends CharacterBody2D

class_name Player

@export var speed := 50

@onready var animator = $AnimatedSprite2D
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
func _physics_process(delta: float) -> void:
	
	var direction = Vector2.ZERO
	

	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		
		if abs(direction.x) > abs(direction.y):
			animator.play("walk_horizontal")
			animator.flip_h = direction.x < 0
		else:
			if direction.y > 0:
				animator.play("walk_down")
			else:
				animator.play("walk_up")
	else:
		animator.play("idle") 
	
	velocity = direction * speed
	move_and_slide()

	if velocity.length() > 0:
		play_walk_animation()
	else:
		play_idle_animation()

func play_idle_animation():
	$AnimatedSprite2D.play("idle")
	
func takeDamage(damage: int):
	pass

func play_walk_animation():
	$AnimatedSprite2D.play("walk")
	
func attack():
	pass

func die():
	pass

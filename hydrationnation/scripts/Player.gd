extends CharacterBody2D

class_name Player
const SPEED = 100.0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * SPEED
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

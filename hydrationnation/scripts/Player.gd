extends CharacterBody2D

class_name Player

@export var speed := 50

@onready var animator = $AnimatedSprite2D
@onready var fishing_rod = $FishingRod

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

			if (direction.x < 0):
				animator.flip_h = true;
				fishing_rod.flip_h = true;
				fishing_rod.z_index = 0;
				fishing_rod.position = Vector2(-14, -12)

			else:
				animator.flip_h = false;
				fishing_rod.flip_h = false;
				fishing_rod.z_index = 2;
				fishing_rod.position = Vector2(32, -8)

		else:
			if direction.y > 0:
				animator.play("walk_down")
				fishing_rod.z_index = 2;
			else:
				animator.play("walk_up")
				fishing_rod.z_index = 0;
	else:
		animator.play("idle")
		fishing_rod.z_index = 2;
		fishing_rod.flip_h = false;
		fishing_rod.position = Vector2(32, -8)
	
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
	
func _ready():
	update_rod_visibility()
	
func update_rod_visibility():
	var current_scene = get_tree().current_scene
	if current_scene.name == "FishingRoom":
		$FishingRod.visible = true;
	else:
		$FishingRod.visible = false;

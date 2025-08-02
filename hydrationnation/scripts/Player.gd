extends CharacterBody2D

class_name Player

@export var speed := 50
var last_direction := Vector2.RIGHT

@onready var animator = $AnimatedSprite2D
@onready var fishing_rod = $FishingRod

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
func _physics_process(delta: float) -> void:

	var direction = Vector2.ZERO

	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	#moving
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		last_direction = direction

		#moving horizontally
		if abs(direction.x) > abs(direction.y): 
			animator.play("walk_horizontal")
	
			#moving left
			if (direction.x < 0):
				animator.flip_h = true;
				fishing_rod.flip_h = true;
				fishing_rod.z_index = 0;
				fishing_rod.position = Vector2(-14, -12)

			#moving right
			else:
				animator.flip_h = false;
				fishing_rod.flip_h = false;
				fishing_rod.z_index = 2;
				fishing_rod.position = Vector2(32, -8)
				
		#moving vertically
		else: 
			
			#moving down
			if direction.y > 0:
				animator.play("walk_down")
				fishing_rod.flip_h = false;
				fishing_rod.z_index = 2;
				fishing_rod.position = Vector2(32, -8)
				
			#moving up
			else:
				animator.play("walk_up")
				fishing_rod.z_index = 0;
				fishing_rod.flip_h = true;
				fishing_rod.position = Vector2(-14, -12)
				
	#stop moving
	else:
		
		#was last moving horizontally
		if abs(last_direction.x) > abs(last_direction.y):
			animator.play("idle_horizontal")
			
		#was last moving vertically
		else:
			
			#was last moving up
			if last_direction.y < 0:
				animator.play("idle_up")
				fishing_rod.flip_h = true;
			
			#was last moving down
			else: 
				animator.play("idle_down")
				fishing_rod.z_index = 2;
				fishing_rod.flip_h = false;
				fishing_rod.position = Vector2(32, -8)
	
	velocity = direction * speed
	move_and_slide()

func takeDamage(damage: int):
	pass
	
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

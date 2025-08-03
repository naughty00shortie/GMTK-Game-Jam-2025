extends CharacterBody2D

class_name Player

@export var speed := 50
var last_direction := Vector2.RIGHT

@onready var animator = $AnimatedSprite2D
@onready var fishing_rod = $FishingRod

enum FishingState { IDLE, CASTING, WAITING, REELING }
var fishing_state = FishingState.IDLE

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
				fishing_rod.position = Vector2(-1, 0)
				
		#moving vertically
		else: 
			
			#moving down
			if direction.y > 0:
				animator.play("walk_down")
				fishing_rod.flip_h = false;
				fishing_rod.z_index = 2;
				fishing_rod.position = Vector2(-1, 0)
				
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
				fishing_rod.position = Vector2(-1, 0)
	
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("fish"):
		speed = 0;
		match fishing_state:
			FishingState.IDLE:
				fishing_rod.play("cast")
			FishingState.WAITING:
				if $Exclamation.visible:
					fishing_rod.play("reel")
					fishing_state = FishingState.REELING
					start_catch_timer()
				else:
					fishing_rod.play("catch")
					speed = 50;
					fishing_rod.frame = 0
					fishing_state = FishingState.IDLE
			FishingState.REELING:
				
				if $Exclamation.visible:
					print("You got a fish!")
				
				fishing_rod.play("catch")
				speed = 50;
				fishing_rod.frame = 0
				fishing_state = FishingState.IDLE
				
			

func takeDamage(damage: int):
	pass
	
func attack():
	pass

func die():
	pass
	
func _ready():
	fishing_rod.frame = 0
	update_rod_visibility()
	fishing_rod.animation_finished.connect(_on_casting_animation_finished)
	
func _on_casting_animation_finished():
	if fishing_rod.animation == "cast":
		fishing_state = FishingState.WAITING
		fishing_rod.play("wait")
		start_wait_timer()
		
func start_wait_timer():
	await get_tree().create_timer(3.0).timeout
	if fishing_state == FishingState.WAITING:
		$Exclamation.position = fishing_rod.position + Vector2(15, -60)	
		$Exclamation.visible = true;
		await get_tree().create_timer(1).timeout
		$Exclamation.visible = false;
		
		if fishing_state != FishingState.REELING:
			fishing_rod.play("catch")
			speed = 50;
			fishing_rod.frame = 0
			fishing_state = FishingState.IDLE
			
func start_catch_timer():
	await get_tree().create_timer(3.0).timeout
	$Exclamation.visible = true;
	await get_tree().create_timer(1).timeout
	$Exclamation.visible = false;
	
	#if fishing_state != FishingState.REELING:
			#fishing_rod.play("catch")
			#speed = 50;
			#fishing_rod.frame = 0
			#fishing_state = FishingState.IDLE
	
func update_rod_visibility():
	var current_scene = get_tree().current_scene
	if current_scene.name == "FishingRoom":
		$FishingRod.visible = true;
	else:
		$FishingRod.visible = false;

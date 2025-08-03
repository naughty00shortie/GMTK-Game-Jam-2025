extends CharacterBody2D

@export var speed := 40
@export var attack_damage := 10
@export var attack_cooldown := 1.5
@export var max_health := 50

@export var pirate_type = 1  # 1 = Melee, 2 = Shooter

var player_ref = null
var current_health = 0
var attack_timer = 0.0
var player_in_vision := false
var player_in_attack_range := false
var is_staggered := false  
var is_attacking := false


#Audio stuff:
@onready var audioPlayer = $AudioStreamPlayer2D  

const explosion_sfx = "res://hydrationnation/audio/soundEffects/explode.wav"
const gunFire_sfx = "res://hydrationnation/audio/soundEffects/gunFire.wav" 
const damage_sfx = "res://hydrationnation/audio/soundEffects/pirateDamage.wav" 


# Load Projectile Scene for Shooter Pirates
var ProjectileScene = preload("res://hydrationnation/scenes/Projectile.tscn")

func _ready():
	current_health = max_health
	$AnimatedSprite2D.play("idle" + str(pirate_type))
	$HealthBar.max_value = max_health
	update_health_bar()

	# Find player by group
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]
	else:
		print("ERROR: No player found in 'player' group!")

	# Connect signals
	$VisionRange.body_entered.connect(_on_vision_range_entered)
	$VisionRange.body_exited.connect(_on_vision_range_exited)
	$AttackRange.body_entered.connect(_on_attack_range_entered)
	$AttackRange.body_exited.connect(_on_attack_range_exited)

func _physics_process(delta):
	if player_ref == null or is_staggered:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	attack_timer -= delta

	# Movement Logic
	if not player_in_attack_range:
		velocity = (player_ref.global_position - global_position).normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# --- Animation Handling ---
	if is_attacking:
		return

	if velocity.length() > 0:
		if pirate_type == 1:
			$AnimatedSprite2D.play("walk1")
		else:
			$AnimatedSprite2D.play("walkshoot2")
	else:
		$AnimatedSprite2D.play("idle" + str(pirate_type))

	# --- Attack Logic ---
	if player_in_attack_range and attack_timer <= 0 and not is_staggered and not is_attacking:
		if pirate_type == 1:
			melee_attack()
		else:
			shoot_projectile()
		attack_timer = attack_cooldown



func melee_attack():
	if player_ref != null:
		player_ref.take_damage(attack_damage)
		print("Pirate (Melee) attacked the player!")

func shoot_projectile():
	if player_ref == null or is_attacking:
		return

	is_attacking = true  # Lock state
	$AnimatedSprite2D.play("shoot2")  # Start shoot animation

	# Wait a bit BEFORE spawning the projectile (adjust for timing sync with animation)
	await get_tree().create_timer(0.3).timeout  # Delay before spawning projectile

	audioPlayer.stream = preload(gunFire_sfx)
	audioPlayer.play()

	var projectile = ProjectileScene.instantiate()
	get_tree().current_scene.add_child(projectile)

	var shoot_direction = (player_ref.global_position - global_position).normalized()
	projectile.global_position = global_position + shoot_direction * 6
	projectile.direction = shoot_direction

	# Prevent instant self-collision
	var collision_shape = projectile.get_node("CollisionShape2D")
	collision_shape.disabled = true
	await get_tree().process_frame
	collision_shape.disabled = false

	# Wait for the rest of the animation to finish before unlocking
	await get_tree().create_timer(0.2).timeout  # This plus previous delay should match the full animation duration

	is_attacking = false  # Unlock state




# --- Signal Callbacks ---
func _on_vision_range_entered(body):
	if body.is_in_group("player"):
		player_in_vision = true
		if pirate_type == 2:
			player_in_attack_range = true  # Shooter uses vision as attack range
		print("Player entered Vision Range!")

func _on_vision_range_exited(body):
	if body.is_in_group("player"):
		player_in_vision = false
		if pirate_type == 2:
			player_in_attack_range = false
		print("Player exited Vision Range!")

func _on_attack_range_entered(body):
	if body.is_in_group("player") and pirate_type == 1:
		player_in_attack_range = true
		print("Player entered Melee Pirate's attack range!")

func _on_attack_range_exited(body):
	if body.is_in_group("player") and pirate_type == 1:
		player_in_attack_range = false
		print("Player exited Melee Pirate's attack range!")

func take_damage(amount: int):
	if is_staggered:
		return 

	current_health -= amount
	update_health_bar()
	print("Pirate took ", amount, " damage. Health left: ", current_health)

	audioPlayer.stream = preload(damage_sfx)
	audioPlayer.play()
	
	flash_red()
	start_stagger(1.0)

	if current_health <= 0:
		die()

func start_stagger(duration: float):
	is_staggered = true
	velocity = Vector2.ZERO  
	await get_tree().create_timer(duration).timeout
	is_staggered = false

func update_health_bar():
	$HealthBar.value = current_health

func flash_red():
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.3)

func die():
	is_staggered = true
	is_attacking = true
	velocity = Vector2.ZERO

	audioPlayer.stream = preload(explosion_sfx)
	audioPlayer.play()

	$HealthBar.visible = false
	$AnimatedSprite2D.play("explode")

	await $AnimatedSprite2D.animation_finished

	queue_free()

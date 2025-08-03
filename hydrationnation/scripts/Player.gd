extends CharacterBody2D

class_name Player

@export var speed := 50
@export var health := 100
@export var max_health := 100
@export var has_sword := false
@export var attack_duration := 0.5

var attack_power := 10
var last_direction := Vector2.RIGHT
var is_attacking := false

@onready var animator = $AnimatedSprite2D
@onready var fishing_rod = $FishingRod
@onready var object_animator = $ObjectAnimator2D
@onready var audioPlayer = $AudioStreamPlayer2D

# Audio
const heavy_quack_sfx = "res://hydrationnation/audio/soundEffects/quack.wav"
const sword_sfx = "res://hydrationnation/audio/soundEffects/sword.wav"
const light_quack_sfx = "res://hydrationnation/audio/soundEffects/lightQuack.wav"

# Fishing
enum FishingState { IDLE, CASTING, WAITING, REELING }
var fishing_state = FishingState.IDLE

func _physics_process(_delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if Input.is_action_just_pressed("attack") and has_sword:
		attack()

	if Input.is_action_just_pressed("fish"):
		handle_fishing_input()

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		last_direction = direction

	handle_animation(direction)
	velocity = direction * speed
	move_and_slide()

func handle_animation(direction: Vector2):
	object_animator.visible = has_sword

	# Sprite flipping and rod positioning
	update_fishing_rod_orientation()

	# Attack takes priority
	if is_attacking and has_sword:
		animator.play("attack")
		object_animator.play("sword_attack")
		return

	# Walk / Idle animations
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			animator.play("walk_horizontal")
			if has_sword:
				object_animator.play("sword_walk_horizontal")
		else:
			if direction.y > 0:
				animator.play("walk_down")
				if has_sword:
					object_animator.play("sword_move_down")
			else:
				animator.play("walk_up")
				if has_sword:
					object_animator.play("sword_move_up")
	else:
		if abs(last_direction.x) > abs(last_direction.y):
			animator.play("idle_horizontal")
			if has_sword:
				object_animator.play("sword_idle_side")
		else:
			if last_direction.y > 0:
				animator.play("idle_down")
				if has_sword:
					object_animator.play("sword_idle_down")
			else:
				animator.play("idle_up")
				if has_sword:
					object_animator.play("sword_idle_up")

func update_fishing_rod_orientation():
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x < 0:
			animator.flip_h = true
			object_animator.flip_h = true
			fishing_rod.flip_h = true
			fishing_rod.z_index = 0
			fishing_rod.position = Vector2(-14, -12)
		else:
			animator.flip_h = false
			object_animator.flip_h = false
			fishing_rod.flip_h = false
			fishing_rod.z_index = 2
			fishing_rod.position = Vector2(16, -8)
	else:
		if last_direction.y < 0:
			fishing_rod.flip_h = true
			object_animator.flip_h = false
			fishing_rod.z_index = 0
			fishing_rod.position = Vector2(-14, -12)
		else:
			fishing_rod.flip_h = false
			object_animator.flip_h = false
			fishing_rod.z_index = 2
			fishing_rod.position = Vector2(16, -8)

func attack() -> void:
	if is_attacking:
		return

	is_attacking = true
	print("Attacking...")

	$SwordHitbox.monitoring = true

	audioPlayer.stream = preload(sword_sfx)
	audioPlayer.play()

	await get_tree().create_timer(attack_duration).timeout

	$SwordHitbox.monitoring = false
	is_attacking = false

func handle_fishing_input():
	if GlobalGameRunner.has_fishing_rod:
		speed = 0
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
					speed = 50
					fishing_rod.frame = 0
					fishing_state = FishingState.IDLE
			FishingState.REELING:
				if $Exclamation.visible:
					print("You got a fish! (give duck sword)")
					
				fishing_rod.play("catch")
				speed = 50
				fishing_rod.frame = 0
				fishing_state = FishingState.IDLE

func take_damage(damage: int):
	print("taking damage: " + str(damage))
	health -= damage
	$HealthBar.visible = true
	$HealthBar.value = health * 100 / max_health
	flash_red()
	audioPlayer.stream = preload(light_quack_sfx)
	audioPlayer.play()
	if health <= 0:
		die()

func flash_red():
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.3)

func die():
	pass

func _ready():
	fishing_rod.frame = 0
	update_rod_visibility()
	$HealthBar.visible = false
	$SwordHitbox.monitoring = false
	$SwordHitbox.body_entered.connect(_on_SwordHitbox_body_entered)
	object_animator.visible = has_sword
	if get_tree().current_scene != null and get_tree().current_scene.scene_file_path == "res://hydrationnation/scenes/Dungeon.tscn":
		equip_sword()
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
		$Exclamation.visible = true
		await get_tree().create_timer(1).timeout
		$Exclamation.visible = false
		if fishing_state != FishingState.REELING:
			fishing_rod.play("catch")
			speed = 50
			fishing_rod.frame = 0
			fishing_state = FishingState.IDLE

func start_catch_timer():
	await get_tree().create_timer(3.0).timeout
	$Exclamation.visible = true
	await get_tree().create_timer(1).timeout
	$Exclamation.visible = false

func update_rod_visibility():
	var current_scene = get_tree().current_scene
	$FishingRod.visible = current_scene.name == "FishingRoom" && GlobalGameRunner.has_fishing_rod

func _on_SwordHitbox_body_entered(body):
	if is_attacking and has_sword and body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(attack_power)
			print("Hit enemy: ", body.name)

func equip_sword():
	has_sword = true
	object_animator.visible = true
	print("Sword Equipped!")

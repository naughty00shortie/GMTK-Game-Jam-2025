extends Node2D

@onready var timer = $Timer
@onready var timerLabel = $CanvasLayer/TimerLabel
@onready var scoreLabel  = $CanvasLayer/ScoreLabel
@onready var hitbars     = [
	$HitBar0,
	$HitBar1,
	$HitBar2,
	$HitBar3,
	$HitBar4,
]

# Inventory items
var has_fishing_rod: bool = false
var has_sword: bool = false
var has_jam: bool = false

signal inventory_changed

func _ready():
	GlobalAudioStreamPlayer.play_playlist()
	print("yeet")
	timerLabel.text = "yeeet"
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _process(_delta: float):
	timerLabel.text = str(int(timer.time_left) % 60)

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://hydrationnation/scenes/main_game_world.tscn")

func set_item_state(item_name: String, state: bool):
	has_fishing_rod = false
	has_sword = false
	match item_name:
		"fishing_rod": has_fishing_rod = state
		"sword": has_sword = state
	emit_signal("inventory_changed")



func get_item_state(item_name: String) -> bool:
	match item_name:
		"fishing_rod": return has_fishing_rod
		"sword": return has_sword
	return false

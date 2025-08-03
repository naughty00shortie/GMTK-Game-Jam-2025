extends Node2D

@onready var timer = $Timer
@onready var timerLabel = $CanvasLayer/TimerLabel

var has_fishing_rod: bool = true;

func _ready():
	GlobalAudioStreamPlayer.play_playlist()
	print("yeet")
	timerLabel.text = "yeeet"
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float):
	timerLabel.text = str(int(timer.time_left) % 60)

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://hydrationnation/scenes/main_game_world.tscn")

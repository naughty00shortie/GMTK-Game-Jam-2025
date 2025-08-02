extends Node2D


@onready var timer = $Timer
@onready var timerLabel = $CanvasLayer/TimerLabel

func _ready():
	GlobalAudioStreamPlayer.play_playlist()
	print("yeet")
	timerLabel.text = "yeeet"
	timer.start()
	
func _process(delta: float):
	timerLabel.text = str(int(timer.time_left) % 60)

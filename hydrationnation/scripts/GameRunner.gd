extends Node


@onready var timer = $Timer
@onready var timerLabel = $CharacterBody2D/TimerLabel


func _ready():
	print("yeet")
	timerLabel.text = "yeeet"
	timer.start()
	
func _process(delta: float):
	timerLabel.text = str(int(timer.time_left) % 60)

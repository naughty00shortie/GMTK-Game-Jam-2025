extends Node2D

@onready var spawner     = $NoteSpawner
@onready var scoreLabel  = $CanvasLayer/ScoreLabel
@onready var scoreTimer = $ScoreTimer

@onready var hitbars = [
	$Hitbar/HitBar0,
	$Hitbar/HitBar1,
	$Hitbar/HitBar2,
	$Hitbar/HitBar3,
	$Hitbar/HitBar4,
]
var score := 0

func _ready() -> void:
	GlobalAudioStreamPlayer.stop()
	for bar in hitbars:
		bar.note_registered.connect(_on_note_hit)
	#scoreTimer.timeout.connect(_on_score_timer)


func _on_note_hit(note: Area2D) -> void:
	score += 100
	scoreLabel.text = str(score)
	if score > 20000:
				var sword_scene = preload("res://hydrationnation/scenes/jam_pick_up.tscn")
				var sword_instance = sword_scene.instantiate()
				sword_instance.position = Vector2(-80.0, 295.0)
				get_tree().current_scene.add_child(sword_instance)

func _on_score_timer() -> void:
	print("Current score:", score)

func _process(delta: float) -> void:
	# Poll all five keys each frame so chords register
	for i in hitbars.size():
		var action_name = "hit_%d" % i
		if Input.is_action_just_pressed(action_name):
			_try_hit(i)

func _try_hit(lane_idx: int) -> void:
	var bar = hitbars[lane_idx]
	if bar.notes_in_zone.size() > 0:
		var note = bar.notes_in_zone.pop_front()
		note.queue_free()
		_on_note_hit(note)

func _exit_tree():
	GlobalAudioStreamPlayer.play_playlist()

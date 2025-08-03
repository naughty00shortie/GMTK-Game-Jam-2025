extends AudioStreamPlayer

const BMP = preload("res://hydrationnation/audio/music/song2.ogg")

var playlist: Array[AudioStream] =[
	preload("res://hydrationnation/audio/music/bgm1.ogg"),
	preload("res://hydrationnation/audio/music/transition.ogg"),
	preload("res://hydrationnation/audio/music/bgm2.ogg"),
	BMP,
	
]

var current_index := 0


func _ready() -> void:
	finished.connect(_on_finished)


func _play_current() -> void:
	var track = playlist[current_index]
	stream = track
	
	if track == BMP:
		stop()
		volume_db = 0
		await get_tree().create_timer(0).timeout
		play()
		#get_tree().create_tween().tween_property(self, "volume_db", 0.0, 1.0)
	else:
		volume_db = 0
		play()


func _on_finished() -> void:
	current_index += 1
	if current_index >= 3:
		current_index = 0
	_play_current()

func play_playlist() -> void:
	current_index = 0
	_play_current()
	

func play_beatmap() -> void:
	current_index = 3
	_play_current()

extends AudioStreamPlayer

var playlist: Array[AudioStream] =[
	preload("res://hydrationnation/audio/music/bgm1.ogg"),
	preload("res://hydrationnation/audio/music/transition.ogg"),
	preload("res://hydrationnation/audio/music/bgm2.ogg"),
	#preload("res://hydrationnation/audio/music/bgm3.ogg"),
	
]

var current_index := 0


func _ready() -> void:
	finished.connect(_on_finished)


func _play_current() -> void:
	stream = playlist[current_index]
	play()


func _on_finished() -> void:
	current_index += 1
	if current_index >= playlist.size():
		current_index = 0
	_play_current()

func play_playlist() -> void:
	current_index = 0
	_play_current()

extends Node2D
signal enable_jam

func _ready():
	# Mute global music when entering this level
	GlobalAudioStreamPlayer.volume_db = -80  # effectively silent
	if GlobalGameRunner.has_jam:
		emit_signal("enable_jam")

func _exit_tree():
	# Restore volume when leaving
	GlobalAudioStreamPlayer.volume_db = 0

    

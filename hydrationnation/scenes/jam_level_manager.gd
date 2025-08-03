extends Node2D


func _ready():
    # Mute global music when entering this level
    GlobalAudioStreamPlayer.volume_db = -80  # effectively silent

func _exit_tree():
    # Restore volume when leaving
    GlobalAudioStreamPlayer.volume_db = 0

    

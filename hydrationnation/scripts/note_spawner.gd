extends Node2D

@export_file("*.json") var beatmap_file: String
@export var lead_time: float = 0
@export var spawn_y: float = -10.0
@export var lane_x_positions: Array[float] = [-60, 260, 580, 900, 1220]
@export var note_scene: PackedScene = preload("res://hydrationnation/scenes/note.tscn")

var beatmap: Array = []
var next_idx: int = 0

@onready var music = GlobalAudioStreamPlayer

func _ready() -> void:
	# load your beatmap
	if beatmap_file == "" or beatmap_file == null:
		push_error("NoteSpawner: beatmap_file not set!")
		return
	beatmap = _load_beatmap(beatmap_file)
	music.play_beatmap()
	set_process(false)
	await get_tree().create_timer(lead_time).timeout
	next_idx = 0
	set_process(true)

func _process(delta: float) -> void:
	# now _process only runs after the lead_time has passed
	if next_idx >= beatmap.size():
		return

	var now: float = music.get_playback_position()
	var entry: Dictionary = beatmap[next_idx]

	if now >= entry.time - lead_time:
		_spawn_note(entry.column)
		next_idx += 1

func _spawn_note(column_idx: int) -> void:
	var note := note_scene.instantiate()
	note.column = column_idx
	note.position = Vector2(lane_x_positions[column_idx], spawn_y)
	add_child(note)

func _load_beatmap(path: String, trim_offset: float = 11.8) -> Array:
	var raw: String = FileAccess.get_file_as_string(path)
	var data = JSON.parse_string(raw)
	if typeof(data) != TYPE_ARRAY:
		push_error("NoteSpawner: Expected a JSON Array in %s, got %s" % [path, typeof(data)])
		return []
	var out := []
	for entry in data:
		var t = entry.time
		if t >= trim_offset:
			out.append({
				"time": t - trim_offset,
				"column": entry.column
			})
	return out

extends Area2D

@export var column_index: int = 0

signal note_registered(note: Area2D)

var notes_in_zone: Array[Area2D] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if area is Note and area.column == column_index:
		notes_in_zone.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area is Note and area.column == column_index:
		notes_in_zone.erase(area)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hit_%d" % column_index) and notes_in_zone.size() > 0:
		emit_signal("note_registered", notes_in_zone.front())

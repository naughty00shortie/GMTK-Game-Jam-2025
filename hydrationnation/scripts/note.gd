class_name Note
extends Area2D

@export var column: int = 0
@export var speed: float = 1200

signal missed(note: Note)
signal hit(note: Note)

# track whether we ever entered the HitBar
var in_zone := false

func _ready() -> void:
	# connect the body_enter/exit signals on the Note itself
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited",  Callable(self, "_on_area_exited"))

func _process(delta: float) -> void:
	position.y += speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.name.begins_with("HitBar"):
		in_zone = true

func _on_area_exited(area: Area2D) -> void:
	if area.name.begins_with("HitBar"):
		# If we exit the hit zone *after* having entered it,
		# and we didn’t queue_free() on a successful hit, it’s a miss:
		if in_zone:
			emit_signal("missed", self)
			queue_free()

extends Sprite2D

@export var speed := 200         # pixels/sec downward
@export var hit_y := 170        # y-position of your HitBar
signal missed

var in_hit_zone := false

func _process(delta):
	position.y += speed * delta
	if position.y > hit_y + 50 and not in_hit_zone:
		emit_signal("missed", self)
		queue_free()

func _on_area_entered(area):
	if area.name == "Hitbar":
		in_hit_zone = true

func _on_area_exited(area):
	if area.name == "Hitbar":
		in_hit_zone = false

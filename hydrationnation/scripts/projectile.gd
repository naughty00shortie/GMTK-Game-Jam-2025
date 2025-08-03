extends Area2D

@export var speed: float = 100  
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	position += direction.normalized() * speed * delta


func _ready():
	$AnimatedSprite2D.play("default")
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(10)
		queue_free()

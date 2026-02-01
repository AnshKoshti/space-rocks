extends Area2D


@export var speed = 1000
var velocity = Vector2.ZERO


# Decides the where bullet spawns.
func start(_transform):
	transform = _transform
	velocity = transform.x * speed


# consistent bullet speed every time.
func _process(delta: float) -> void:
	position += velocity * delta


# Bullet memory frees when leaves screen bounds.
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


# This detects when bullet enters rocks body.
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("rocks"):
		body.explode()
		queue_free()

extends Area2D

@export var bullet_scene : PackedScene
@export var speed = 150
@export var rotation_speed = 120
@export var health = 3
var follow = PathFollow2D.new()
var target = null


func _on_gun_cooldown_timeout() -> void:
	pass # Replace with function body.

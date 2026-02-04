extends RigidBody2D

@export var engine_power = 500
@export var spin_power = 8000
@export var bullet_scene : PackedScene
@export var fire_rate = 0.25


enum {INIT, ALIVE, INVULNERABLE, DEAD}
var state = INIT
var thrust = Vector2.ZERO
var rotation_dir = 0
var screensize = Vector2.ZERO
var can_shoot = true


func _ready() -> void:
	change_state(ALIVE)
	screensize = get_viewport_rect().size
	$GunCoolDown.wait_time = fire_rate


func _process(_delta: float) -> void:
	get_input()


func _physics_process(_delta: float) -> void:
	constant_force = thrust
	constant_torque = rotation_dir * spin_power


func _integrate_forces(_physics_state: PhysicsDirectBodyState2D) -> void:
	var xform = _physics_state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screensize.x)
	xform.origin.y = wrapf(xform.origin.y, 0, screensize.y)
	_physics_state.transform = xform


func change_state(new_state):
	match new_state:
		INIT:
			$CollisionShape2D.set_deferred("disabled", true)
		ALIVE:
			$CollisionShape2D.set_deferred("disabled", false)
		INVULNERABLE:
			$CollisionShape2D.set_deferred("disabled", true)
		DEAD:
			$CollisionShape2D.set_deferred("disabled", true)
	state = new_state


func get_input():
	thrust = Vector2.ZERO
	if state in [DEAD, INIT]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
	rotation_dir = Input.get_axis("rotate_left", "rotate_right")
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()


func shoot():
	if state == INVULNERABLE:
		return
	can_shoot = false
	$GunCoolDown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start($Muzzle.global_transform)


# This signal allow ship to shoot again.
func _on_gun_cool_down_timeout() -> void:
	can_shoot = true

extends Node2D

signal prepared_to_shoot
signal shot_completed

onready var ShootAudio = get_parent().get_node("ShootAudio")

export var fire_rate = 0.3
export var shot_speed = 50
export var is_homing = false

var fire_time = 0.0
var BulletScene = preload("res://scenes/Bullet.tscn")


func shoot(velocity_x = 0):
	if get_time() - fire_time < fire_rate:
		return
	fire_time = get_time()
	var b = BulletScene.instance()

	get_tree().get_root().add_child(b)

	var rot = get_parent().global_rotation
	var fire_y = 1

	if is_homing:
		# var dir = (Global.Player.global_position - global_position).normalized()
		# rot = acos(dir.x) + PI * -1
		rot = global_position.angle_to(Global.Player.global_position) + PI / 2

	if global_position.y > Global.middle.y:
		fire_y = -1

	var fire_direction = Vector2(0, fire_y).rotated(rot)
	b.start(global_position, fire_direction, shot_speed, velocity_x, get_parent() == Global.Player)

	ShootAudio.play()

	emit_signal("shot_completed")


func get_time():
	return OS.get_ticks_msec() / 1000.0


func _on_CooldownTimer_timeout():
	emit_signal("prepared_to_shoot")
	shoot()

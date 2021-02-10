extends Node2D

export var fire_rate = 0.3
export var shot_speed = 50

var fire_time = 0.0
var Bullet = preload("res://scenes/Bullet.tscn")
onready var ShootAudio = get_parent().get_node("ShootAudio")


func shoot(velocity_x = 0):
	if get_time() - fire_time < fire_rate:
		return
	fire_time = get_time()
	var b = Bullet.instance()

	get_tree().get_root().add_child(b)

	b.start(global_position, get_parent().rotation, shot_speed, velocity_x, get_parent().is_in_group('player'))

	b.sprite.set_visible(true)

	# todo - homing shot for enemy
	# if get_parent().is_in_group("homing"):
	# 	var dir = (Global.Player.global_position - global_position).normalized()
	# 	print(dir)
	# 	b.fire_direction = dir
	# 	b.rotation = dir.angle() + PI / 2.0

	ShootAudio.play()


func get_time():
	return OS.get_ticks_msec() / 1000.0


func _on_CooldownTimer_timeout():
	shoot()

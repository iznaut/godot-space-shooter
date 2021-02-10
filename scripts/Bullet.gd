extends KinematicBody2D

var shot_speed = 50
var fire_direction
var velocity = Vector2()
var bounce_count = 3
var sprite

signal bullet_state_changed(new_bullet)


func _ready():
	connect("bullet_state_changed", Global.HUD, "update_bullet_pips")


func start(pos, rot, speed, velocity_x, isPlayer):
	if isPlayer:
		fire_direction = Vector2.UP.rotated(rot)
		fire_direction.x += velocity_x
		set_collision_layer_bit(0, true)
		sprite = get_node("BlueSprite")
		add_to_group("player_bullets")
		emit_signal("bullet_state_changed", true)
	else:
		fire_direction = Vector2.DOWN
		set_collision_layer_bit(1, true)
		sprite = get_node("RedSprite")
		add_to_group("enemy_bullets")

	position = pos
	velocity = fire_direction
	shot_speed = speed


func _physics_process(delta):
	var collision = move_and_collide(velocity * shot_speed * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		bounce_count -= 1
		modulate.a -= 0.1 * bounce_count

		if collision.collider.has_method("hit"):
			collision.collider.hit(velocity)
		else:
			$WallHitAudio.play()

		if bounce_count <= 0:
			$DestroyedAudio.play()
			yield($DestroyedAudio, "finished")
			# remove_from_group("player_bullets")
			queue_free()


func _exit_tree():
	if is_in_group("player_bullets"):
		emit_signal("bullet_state_changed", false)
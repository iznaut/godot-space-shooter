extends KinematicBody2D
class_name Bullet

var shot_speed = 50
var fire_direction
var velocity = Vector2()
var bounce_count = 3
var sprite

signal player_bullet_created(bullet)
signal bullet_state_changed(new_bullet)


func _ready():
	connect("bullet_state_changed", Global.HUD, "update_bullet_pips")
	connect("player_bullet_created", Global.EnemyManager, "_on_Player_Bullet_Created")


func start(pos, rot, speed, velocity_x, isPlayer):
	if isPlayer:
		fire_direction = Vector2.UP.rotated(rot)
		fire_direction.x += velocity_x
		set_collision_layer_bit(2, true)
		# set_collision_mask_bit(4, true)
		set_collision_mask_bit(1, true)
		sprite = get_node("BlueSprite")
		add_to_group("player_bullets")
		emit_signal("bullet_state_changed", true)
		emit_signal("player_bullet_created", self)
	else:
		fire_direction = Vector2.DOWN
		set_collision_layer_bit(3, true)
		set_collision_mask_bit(0, true)
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

		if collision.collider is Enemy:
			collision.collider.hit(velocity)
		else:
			$WallHitAudio.play()

		if bounce_count <= 0:
			$DestroyedAudio.play()
			visible = false
			yield($DestroyedAudio, "finished")
			queue_free()


func _exit_tree():
	if is_in_group("player_bullets"):
		emit_signal("bullet_state_changed", false)

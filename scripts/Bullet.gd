extends KinematicBody2D
class_name Bullet

signal bullet_state_changed(this)
signal player_bullet_hit
signal player_bullet_missed

var shot_speed = 50
var fire_direction
var velocity = Vector2()
var bounce_count = 3
var sprite
var has_hit = false


func _ready():
	connect("bullet_state_changed", Global.UI, "update_bullet_pips")
	connect("bullet_state_changed", Global.EnemyManager, "_on_Player_Bullet_Created")
	connect("player_bullet_hit", ScoreManager, "add_multiplier")
	connect("player_bullet_missed", ScoreManager, "reset_multiplier")

	add_to_group("bullets")


func start(pos, fire_direction, speed, velocity_x, isPlayer):
	if isPlayer:
		fire_direction.x += velocity_x
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(1, true)
		sprite = get_node("BlueSprite")
		add_to_group("player_bullets")
		emit_signal("bullet_state_changed", self)
	else:
		set_collision_layer_bit(3, true)
		set_collision_mask_bit(0, true)
		sprite = get_node("RedSprite")
		add_to_group("enemy_bullets")

	position = pos
	velocity = fire_direction
	shot_speed = speed
	sprite.show()


func _physics_process(delta):
	var collision = move_and_collide(velocity * shot_speed * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		bounce_count -= 1
		modulate.a -= 0.1 * bounce_count

		if collision.collider is Enemy:
			collision.collider.hit(velocity)

		if !collision.collider.is_in_group("walls"):
			has_hit = true
			emit_signal("player_bullet_hit")
		else:
			$WallHitAudio.play()

		if bounce_count <= 0:
			$DestroyedAudio.play()
			visible = false
			yield($DestroyedAudio, "finished")

			if !has_hit:
				emit_signal("player_bullet_missed")

			queue_free()


func _exit_tree():
	if is_in_group("player_bullets"):
		emit_signal("bullet_state_changed", null)

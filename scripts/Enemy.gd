extends KinematicBody2D
class_name Enemy

export (int) var hit_limit = 1
export (float) var path_move_speed = 2.5
export (int) var path_dir = 1
export (float, EASE) var t
export (Curve) var movement_curve

enum STATE {ALIVE, FALLING, DEAD}
var state = STATE.ALIVE
var hit_count = 0
var velocity = Vector2()
var parent_path

var CoinScene = preload("res://scenes/Coin.tscn")

signal enemy_hit(trauma, time)
# signal enemy_destroyed


func _ready():
	connect("tree_exited", Global.EnemyManager, "_on_Enemy_tree_exited")
	connect("enemy_hit", Global, "shake_screen")
	# connect("enemy_destroyed", ScoreManager, "add_multiplier")

	add_to_group("enemies")


func _physics_process(delta):
	if state == STATE.ALIVE:
		if parent_path and not $EnterTween.is_active():
			# if Global.wave_count < 10 and $CooldownTimer.time_left < 0.5:
			# 	return
			move_along_path(delta, true)
	else:
		velocity.y += Global.GRAVITY * delta
		velocity = move_and_slide(velocity, Vector2(0, -1))


func flyIn(enter_position):
	$EnterTween.interpolate_property(
		self, "position", position,
		enter_position, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT
	)

	$EnterTween.start()
	hit_cooldown(0.5)


func hit(direction):
	$HitAudio.pitch_scale = 1 + (0.2 * hit_count)
	$HitAudio.play()

	if state == STATE.ALIVE:
		$CooldownTimer.stop()
		state = STATE.FALLING
		$AnimatedSprite.play("hit")

	rotate(direction.x + hit_count)
	hit_count += 1
	velocity -= (direction * Global.GRAVITY) * hit_count
	var mod = 1 - (hit_count * 0.2)
	$AnimatedSprite.modulate = Color(mod,mod,mod,1)

	var coin = CoinScene.instance()
	coin.global_position = global_position
	Global.World.add_child(coin)
	if Global.rng.randi_range(0, 4) == 0:
		coin.get_node("AnimationPlayer").play("glow")
		coin.set_collision_layer_bit(2, true)
		coin.set_collision_mask_bit(2, true)
		coin.special = true

	if hit_count >= hit_limit:
		state = STATE.DEAD
		# emit_signal("enemy_destroyed")

	# shake camera on hit
	emit_signal("enemy_hit", 0.2, 0.1 * hit_count)

	if state == STATE.DEAD:
		$CollisionShape2D.disabled = true
		
		$KillAudio.pitch_scale = 1 + (0.2 * ScoreManager.multiplier)
		$KillAudio.play()

		$ExitTween.interpolate_property(
			self, "scale", scale,
			Vector2(), 1, Tween.TRANS_CIRC, Tween.EASE_OUT
		)

		$ExitTween.start()
		yield($ExitTween, "tween_completed")
		queue_free()
	else:
		hit_cooldown(1)


func move_along_path(delta, loop):
	# t += (path_dir * move_speed) * delta
	t += movement_curve.interpolate_baked(path_move_speed * delta)

	position = parent_path.curve.interpolate_baked(t * parent_path.curve.get_baked_length())
	# 	print(t)

	if loop and t >= 1:
		# loop
		t = 0.0
	else:
		# reverse
		if t >= 1:
			path_dir = -1
		if t <= 0:
			path_dir = 1


func hit_cooldown(seconds):
	set_collision_mask_bit(0, false)
	yield(get_tree().create_timer(seconds), "timeout")
	set_collision_mask_bit(0, true)

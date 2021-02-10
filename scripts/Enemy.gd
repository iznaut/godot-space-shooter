extends KinematicBody2D
class_name Enemy

export (int) var path_move_speed = 1
export (int) var score_value = 10
export (int) var gravity = 50
export (float, EASE) var t
export (Curve) var movement_curve

var falling = false
var dead = false
var hit_count = 0
var velocity = Vector2()
var path_dir = 1
var hit_rotate = 40

signal hit(body)


func _ready():
	connect("tree_exited", Global.EnemyManager, "_on_Enemy_tree_exited")
	connect("hit", ScoreManager, "add_score")
	connect("hit", Global.Player, "_on_Enemy_hit")


func _physics_process(delta):
	if !falling:
		# move_along_path(delta, true)
		pass
	else:
		velocity.y += gravity * delta
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

	if !falling:
		$CooldownTimer.stop()
		falling = true
		$AnimatedSprite.play("hit")

	rotate(direction.x + hit_count)
	hit_count += 1
	velocity -= (direction * gravity) * hit_count
	var mod = 1 - (hit_count * 0.2)
	$AnimatedSprite.modulate = Color(mod,mod,mod,1)

	if hit_count >= 3:
		dead = true

	emit_signal("hit", self)

	if dead:
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

	position = get_parent().curve.interpolate_baked(t * get_parent().curve.get_baked_length())
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
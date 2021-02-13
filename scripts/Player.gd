extends KinematicBody2D

export var move_speed = 50
export var turn_direction = 1
enum PLAYER_CLASS {DEFAULT, SNIPER}
export (PLAYER_CLASS) var player_class

var bullet_limit = 3
var stunned = false


func _ready():
	if player_class == PLAYER_CLASS.SNIPER:
		move_speed = 30
		bullet_limit = 1
		$FiringPoint.shot_speed = 70


func _physics_process(delta):
	var move_vec = Vector2()

	if !stunned:
		if Input.is_action_pressed("move_left"):
			if player_class == PLAYER_CLASS.SNIPER and Input.is_action_pressed("secondary_action"):
				var m_rotation = rotation - 0.1
				m_rotation = clamp(m_rotation, -PI/3, PI/3)
				rotation = m_rotation
			else:
				move_vec.x -= 1
		if Input.is_action_pressed("move_right"):
			if player_class == PLAYER_CLASS.SNIPER and Input.is_action_pressed("secondary_action"):
				var m_rotation = rotation + 0.1
				m_rotation = clamp(m_rotation, -PI/3, PI/3)
				rotation = m_rotation
			else:
				move_vec.x += 1

	if Input.is_action_just_pressed("primary_action"):
		var bullet_count = get_tree().get_nodes_in_group("player_bullets").size()

		if bullet_count < bullet_limit:
			$FiringPoint.rotation = rotation
			$FiringPoint.shoot(move_vec.x)	


	if move_vec:
		if player_class == PLAYER_CLASS.SNIPER:
			pass
		else:
			$Tween.interpolate_property(
				self, "rotation", rotation,
				turn_direction * (move_vec.x / 2), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN
			)
			$Tween.start()
	else:
		if player_class == PLAYER_CLASS.SNIPER:
			pass
		else:
			$Tween.interpolate_property(
				self, "rotation", rotation,
				0, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN
			)
			$Tween.start()

	var collision = move_and_collide(move_vec * delta * move_speed)

	if collision:
		var body = collision.collider

		if body is Global.Enemy:
			stun()
		elif body is Global.Bullet:
			get_tree().paused = true
			Global.game_over = true


func stun():
	stunned = true
	$StunCooldown.wait_time = 0.4
	$StunCooldown.start()
	Global.Camera.trauma = 0.4
	yield($StunCooldown, "timeout")
	stunned = false
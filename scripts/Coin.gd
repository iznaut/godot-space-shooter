extends Area2D
class_name Coin

var score_value = 5
var special = false
var velocity = Vector2.ZERO

signal coin_collected(value)


func _ready():
	connect("coin_collected", ScoreManager, "add_score")


func _physics_process(delta):
	velocity.y += 1 * delta
	position += velocity


func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("coin_collected", score_value)
		$CoinCollectAudio.play()
		visible = false
		yield($CoinCollectAudio, "finished")
		queue_free()
	else:
		if body.is_in_group("player_bullets"):
			if special:
				$CoinHitAudio.play()
				velocity += velocity.bounce(body.velocity) * 2
				scale = scale + Vector2(0.1, 0.1)
				$AnimationPlayer.playback_speed += 1
				hit_cooldown(0.5)
				body.queue_free()
				score_value *= 2
		elif body.is_in_group("walls"):
			velocity = velocity.bounce(body.constant_linear_velocity)
		


func hit_cooldown(seconds):
	special = false
	yield(get_tree().create_timer(seconds), "timeout")
	special = true

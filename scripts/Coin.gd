extends RigidBody2D
class_name Coin

signal coin_juggled(value)

var score_value = 50
var special = false


func _ready():
	connect("coin_juggled", ScoreManager, "add_score")


func _on_body_entered(body):
# 	if body.is_in_group("player"):
# 		emit_signal("coin_collected", score_value)
# 		$CoinCollectAudio.play()
# 		visible = false
# 		yield($CoinCollectAudio, "finished")
# 		queue_free()
# 	else:
	if body.is_in_group("player_bullets"):
		body.queue_free()

		if special:
			$CoinHitAudio.play()
			$AnimationPlayer.playback_speed += 1
			hit_cooldown(0.5)
			emit_signal("coin_juggled", 5)
		elif body.is_in_group("walls"):
			linear_velocity = linear_velocity.bounce(body.constant_linear_velocity)


func hit_cooldown(seconds):
	special = false
	yield(get_tree().create_timer(seconds), "timeout")
	special = true

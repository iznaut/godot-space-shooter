extends Area2D

signal enemy_dropped(body)


func _ready():
	connect("enemy_dropped", ScoreManager, "reset_multiplier")


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		emit_signal("enemy_dropped", body)

	body.queue_free()

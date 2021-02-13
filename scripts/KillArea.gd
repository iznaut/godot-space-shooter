extends Area2D

signal enemy_dropped(body)


func _ready():
	connect("enemy_dropped", ScoreManager, "reset_multiplier")


func _on_Area2D_body_entered(body):
	# todo would rather use gdscript classes
	if body is Global.Enemy:
		emit_signal("enemy_dropped")

	body.queue_free()

extends Node

var score = 0
var multiplier = 1

signal score_updated(message)
signal multi_updated


func _ready():
	connect("score_updated", Global.HUD, "set_score_display_text")
	connect("multi_updated", Global.HUD, "set_multi_display_text")


func add_score(enemy_body):
	score += enemy_body.score_value * multiplier
	emit_signal("score_updated", "Score:\n" + String(score))

	if enemy_body.dead:
		multiplier += 1
		emit_signal("multi_updated", "multi x" + String(multiplier))


func reset_multiplier():
	if multiplier > 1:
		multiplier = 1
		emit_signal("multi_updated")
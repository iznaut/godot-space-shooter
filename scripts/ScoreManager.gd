extends Node

var score = 0
var multiplier = 1

signal score_updated(added_score)
signal multi_updated


func _ready():
	connect("score_updated", Global.UI, "set_score_display_text")
	connect("multi_updated", Global.UI, "set_multi_display_text")


func add_score(value):
	var added_score = value * multiplier
	score += added_score

	emit_signal("score_updated", added_score)


func add_multiplier():
	multiplier += 1
	emit_signal("multi_updated", "multi x" + String(multiplier)) 


func reset_multiplier():
	if multiplier > 1:
		multiplier = 1
		emit_signal("multi_updated")

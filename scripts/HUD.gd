extends Control

export (AudioStreamSample) var confirm_start_sfx
export (AudioStreamSample) var pause_sfx

onready var start_label = $StartLabel
onready var game_display = $GameInProgress
onready var score_display = game_display.get_node("ScoreLabel")
onready var multi_display = game_display.get_node("MultiLabel")
onready var bullet_display = game_display.get_node("BulletDisplay")

# var message_queue = []

# func _process(_delta):
# 	if message_queue.size() > 0:
# 		for msg in message_queue:
# 			set_score_display_text(msg)
# 			yield(get_tree().create_timer(3), "timeout")
# 			message_queue.pop_front()


# func queue_message(message):
# 	message_queue.push_back(message)


func set_score_display_text(text):
	score_display.text = text


func set_multi_display_text(text = false):
	if !text:
		multi_display.hide()
		get_node("ComboLostAudio").play()
	else:
		multi_display.text = text
		multi_display.show()


	# Global.MultiLabel.rect_position = global_position - Vector2(8,4)
	# Global.MultiLabel.text = String(ScoreManager.multiplier) + 'x'
	# Global.MultiLabel.visible = true

func _on_game_started():
	score_display.text = "score:\n0"
	multi_display.text = "multi x2"
	start_label.hide()
	game_display.show()
	

func update_bullet_pips(new_bullet):
	var bullet_pips = bullet_display.get_children()
	var pip_updated = false
	var index = 0

	if !new_bullet:
		bullet_pips.invert()

	while !pip_updated:
		if new_bullet && bullet_pips[index].visible == true:
			bullet_pips[index].hide()
			pip_updated = true
		elif !new_bullet && bullet_pips[index].visible == false:
			bullet_pips[index].show()
			pip_updated = true
		else:
			index += 1

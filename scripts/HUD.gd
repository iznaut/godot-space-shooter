extends Control

export (AudioStreamSample) var confirm_start_sfx
export (AudioStreamSample) var pause_sfx

export var sfx_enabled = true

onready var start_label = $StartLabel
onready var game_display = $GameInProgress
onready var score_display = game_display.get_node("ScoreLabel")
onready var multi_display = game_display.get_node("MultiLabel")
onready var bullet_display = game_display.get_node("BulletDisplay")


func _ready():
	if !sfx_enabled:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -99)


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

	while !pip_updated:
		if index < bullet_pips.size():
			var pip = bullet_pips[index]

			if new_bullet and pip.visible:
				pip.hide()
				pip_updated = true
			elif !new_bullet and !pip.visible:
				pip.show()
				pip_updated = true
			
			index += 1
		else:
			return

extends Button

onready var soundPlayer = get_node("../../../../AudioStreamPlayer")

func _on_SaveReturnButton_pressed():
	#save current keymapping
	get_parent().get_parent().get_parent().get_parent().save_keymap()
	
	#return to title screen
	get_node("/root/global").gotoScene("res://TitleScene/TitleScreen.tscn")


func _on_SaveReturnButton_focus_entered():
	soundPlayer.play()

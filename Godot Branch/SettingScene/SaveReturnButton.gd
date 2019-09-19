extends Button

func _on_SaveReturnButton_pressed():
	#save current keymapping
	get_parent().get_node("ControlsMenu").save_keymap()
	
	#return to title screen
	get_node("/root/global").gotoScene("res://TitleScene/TitleScreen.tscn")

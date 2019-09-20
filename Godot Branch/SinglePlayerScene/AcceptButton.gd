extends Button

func _on_AcceptButton_pressed():
	#return to title screen
	get_node("/root/global").gotoScene("res://TitleScene/TitleScreen.tscn")

extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("SinglePlayerButton").grab_focus()


#Handle button signals
func _on_SinglePlayerButton_pressed():
	get_node("/root/global").gotoScene("res://SinglePlayerScene/stage1.tscn")

func _on_SettingsButton_pressed():
	get_node("/root/global").gotoScene("res://SettingScene/SettingsScreen.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

extends Button

var menuController

func _ready():
	menuController = get_parent()

func _on_Button_focus_entered():
	menuController.playAudio("move")

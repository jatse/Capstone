extends VBoxContainer

onready var soundPlayer = get_node("MenuSounds")

# Called when the node enters the scene tree for the first time.
func _ready():
	#focus cursor at top of the list
	get_node("SinglePlayerButton").grab_focus()


#Handle button signals
func _on_SinglePlayerButton_pressed():
	playAudio("singlePlayer")

func _on_SettingsButton_pressed():
	playAudio("settings")

func _on_QuitButton_pressed():
	playAudio("quit")


#plays audio depending on action
func playAudio(track):
	#load corresponding track
	if track == "move":
		soundPlayer.stream = load("res://Assets/sounds/menu_move.wav")
	else:
		soundPlayer.stream = load("res://Assets/sounds/menu_select.wav")
			
	#play audio
	soundPlayer.play()
	
	#do action if needed
	if track == "move":
		return
	else:
		#if action needed, let audio finish
		var currentTime = OS.get_ticks_msec()
		while OS.get_ticks_msec() < currentTime + 500:
			pass
		
		#do action accordingly
		if track == "singlePlayer":
			get_node("/root/global").gotoScene("res://SinglePlayerScene/stage1.tscn")
		elif track == "settings":
			get_node("/root/global").gotoScene("res://SettingScene/SettingsScreen.tscn")
		elif track == "quit":
			get_tree().quit()	
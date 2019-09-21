extends Control

#The default key map
var default_controls = {
	"LeftForwardKey" : KEY_E,
	"LeftBackwardKey" : KEY_D,
	"LeftStrafeKey" : KEY_S,
	"LeftFireKey" : KEY_F,
	"RightForwardKey" : KEY_I,
	"RightBackwardKey" : KEY_K,
	"RightStrafeKey" : KEY_L,
	"RightFireKey" : KEY_J
}

#The key map for this game instance
var controls = {}

#onscreen button variables
var leftForwardKey
var leftBackwardKey
var leftStrafeKey
var leftFireKey
var rightForwardKey
var rightBackwardKey
var rightStrafeKey
var rightFireKey

onready var soundPlayer = get_node("AudioStreamPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	#map onscreen keys to variables
	leftForwardKey = get_node("HBoxContainer/MenuPanel/SettingsMenu/ControlsMenu/LeftForwardKey/AssignedKey")
	leftBackwardKey = get_node("HBoxContainer/MenuPanel/SettingsMenu/ControlsMenu/LeftBackwardKey/AssignedKey")
	leftStrafeKey = get_node("HBoxContainer/MenuPanel/SettingsMenu/ControlsMenu/LeftStrafeKey/AssignedKey")
	leftFireKey = get_node("HBoxContainer/MenuPanel/SettingsMenu/ControlsMenu/LeftFireKey/AssignedKey")
	rightForwardKey = get_node("HBoxContainer/MenuPanel/SettingsMenu/ControlsMenu/RightForwardKey/AssignedKey")
	rightBackwardKey = get_node("HBoxContainer/MenuPanel/SettingsMenu/ControlsMenu/RightBackwardKey/AssignedKey")
	rightStrafeKey = get_node("HBoxContainer/MenuPanel/SettingsMenu/ControlsMenu/RightStrafeKey/AssignedKey")
	rightFireKey = get_node("HBoxContainer/MenuPanel/SettingsMenu/ControlsMenu/RightFireKey/AssignedKey")
	
	#start selection on top of list
	leftForwardKey.get_parent().get_child(0).grab_focus()
	
	#If config file not exist, make default file
	var configFile = File.new()
	if configFile.open("user://controls.cfg", File.READ_WRITE) == 1:
		configFile.store_line(to_json(default_controls))
		configFile.close()
		
	#Load config file
	configFile.open("user://controls.cfg", File.READ)
	controls = parse_json(configFile.get_line())
	configFile.close()
		
	#Compare keys to check for empty/incomplete
	if controls == null || default_controls.keys().sort() != controls.keys().sort():
		print("key mismatch")
		#Set default if corrupt keys
		set_keys_to_default()
		
	#Update UI
	update_keymap_UI()
	
#Refreshes UI labels for current keymap.
#Call this function when keymap has been edited.
func update_keymap_UI():
	leftForwardKey.text = get_input_name(controls["LeftForwardKey"])
	leftBackwardKey.text = get_input_name(controls["LeftBackwardKey"])
	leftStrafeKey.text = get_input_name(controls["LeftStrafeKey"])
	leftFireKey.text = get_input_name(controls["LeftFireKey"])
	
	rightForwardKey.text = get_input_name(controls["RightForwardKey"])
	rightBackwardKey.text = get_input_name(controls["RightBackwardKey"])
	rightStrafeKey.text = get_input_name(controls["RightStrafeKey"])
	rightFireKey.text = get_input_name(controls["RightFireKey"])
	
	#update player
	get_node("../../../Player").load_input_map()

#Sets the current controls to default controls
func set_keys_to_default():
	controls = default_controls.duplicate()
	update_keymap_UI()
	
#Changes key mapping for game instance
func map_key_to_action(code, action):
	controls[action] = code
	update_keymap_UI()
	
#Changes input code to string
func get_input_name(code):
	if code >= 17: #non joypad codes
		return OS.get_scancode_string(code)
	else: #joypad codes
		return Input.get_joy_button_string(code)
		
#Save current keymap to file
func save_keymap():
	var configFile = File.new()
	if configFile.open("user://controls.cfg", File.WRITE) == OK:
		configFile.store_line(to_json(controls))
		configFile.close()

func playAudio():
	soundPlayer.play()

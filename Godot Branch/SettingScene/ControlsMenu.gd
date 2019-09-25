extends Control

#The default key map
var default_controls = {
	#Format is ["event class", global enum value, axis orientation (-1, 0 for N/A, or 1)
	"LeftForwardKey" : ["InputEventKey", KEY_E, 0],
	"LeftBackwardKey" : ["InputEventKey", KEY_D, 0],
	"LeftStrafeKey" : ["InputEventKey", KEY_S, 0],
	"LeftFireKey" : ["InputEventKey", KEY_F, 0],
	"RightForwardKey" : ["InputEventKey", KEY_I, 0],
	"RightBackwardKey" : ["InputEventKey", KEY_K, 0],
	"RightStrafeKey" : ["InputEventKey", KEY_L, 0],
	"RightFireKey" : ["InputEventKey", KEY_J, 0]
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
	
#Saves input information to controls dictionary
func map_key_to_action(eventtype, code, action, axisValue = 0):
	var roundedAxis = 0
	if axisValue > 0:
		roundedAxis = 1
	elif axisValue < 0:
		roundedAxis = -1
	controls[action] = [eventtype, code, roundedAxis]
	update_keymap_UI()
	
#Changes input code to string
func get_input_name(inputValueArray):
	if inputValueArray[0] == "InputEventKey":
		return OS.get_scancode_string(inputValueArray[1])
	if inputValueArray[0] == "InputEventJoypadButton":
		return Input.get_joy_button_string(inputValueArray[1])
	if inputValueArray[0] == "InputEventJoypadMotion":
		if inputValueArray[2] > 0:
			return Input.get_joy_axis_string(inputValueArray[1])
		else:
			return str("-" + Input.get_joy_axis_string(inputValueArray[1]))
		
#Save current keymap to file
func save_keymap():
	var configFile = File.new()
	if configFile.open("user://controls.cfg", File.WRITE) == OK:
		configFile.store_line(to_json(controls))
		configFile.close()

func playAudio():
	soundPlayer.play()

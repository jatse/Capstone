extends VBoxContainer

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

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("LeftForwardKey/ChangeKey").grab_focus()
	
	#If config file not exist, make default file
	var configFile = File.new()
	if configFile.open("res://controls.cfg", File.READ_WRITE) != OK:
		configFile.store_line(to_json(default_controls))
		configFile.close()
		
	#Load config file
	configFile.open("res://controls.cfg", File.READ)
	controls = parse_json(configFile.get_line())
	configFile.close()
		
	#Compare keys to check for empty/incomplete
	if controls == null || default_controls.keys() != controls.keys():
		#Set default if corrupt keys
		set_keys_to_default()
		
	#Update UI
	update_keymap_UI()
	
#Refreshes UI labels for current keymap.
#Call this function when keymap has been edited.
func update_keymap_UI():
	get_node("LeftForwardKey/AssignedKey").text = OS.get_scancode_string(controls["LeftForwardKey"])
	get_node("LeftBackwardKey/AssignedKey").text = OS.get_scancode_string(controls["LeftBackwardKey"])
	get_node("LeftStrafeKey/AssignedKey").text = OS.get_scancode_string(controls["LeftStrafeKey"])
	get_node("LeftFireKey/AssignedKey").text = OS.get_scancode_string(controls["LeftFireKey"])
	
	get_node("RightForwardKey/AssignedKey").text = OS.get_scancode_string(controls["RightForwardKey"])
	get_node("RightBackwardKey/AssignedKey").text = OS.get_scancode_string(controls["RightBackwardKey"])
	get_node("RightStrafeKey/AssignedKey").text = OS.get_scancode_string(controls["RightStrafeKey"])
	get_node("RightFireKey/AssignedKey").text = OS.get_scancode_string(controls["RightFireKey"])

#Sets the current controls to default controls
func set_keys_to_default():
	controls = default_controls.duplicate()
	
#Changes key mapping for game instance
func map_key_to_action(code, action):
	controls[action] = code
	update_keymap_UI()
	
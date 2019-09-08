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
	get_node("LeftForwardKey/AssignedKey").text = get_input_name(controls["LeftForwardKey"])
	get_node("LeftBackwardKey/AssignedKey").text = get_input_name(controls["LeftBackwardKey"])
	get_node("LeftStrafeKey/AssignedKey").text = get_input_name(controls["LeftStrafeKey"])
	get_node("LeftFireKey/AssignedKey").text = get_input_name(controls["LeftFireKey"])
	
	get_node("RightForwardKey/AssignedKey").text = get_input_name(controls["RightForwardKey"])
	get_node("RightBackwardKey/AssignedKey").text = get_input_name(controls["RightBackwardKey"])
	get_node("RightStrafeKey/AssignedKey").text = get_input_name(controls["RightStrafeKey"])
	get_node("RightFireKey/AssignedKey").text = get_input_name(controls["RightFireKey"])
	
	#update player
	get_node("../../../../../../../3DDemo/Viewport/Player").load_input_map()

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
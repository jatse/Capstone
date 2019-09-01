extends Spatial

#holds keymapping
var controls = {}
var animation_player

# Called when the node enters the scene tree for the first time.
func _ready():
	#get animator
	animation_player = get_node("AnimationPlayer")
	
	#map keys to actions
	load_input_map()

#reads in config file to get keymap
#defaults to default key map if file not exits
func load_input_map():
	controls = get_node("../HBoxContainer/MenuPanel/SettingsMenu/ControlsMenu").controls.duplicate()

func _input(event):
	#convert event to code
	var code
	
	#account for keyboard and gamepad
	if event is InputEventKey:
		code = event.scancode
	if event is InputEventJoypadButton:
		code = event.button_index

	#call respective method
	#controls only react from idle state
	if code == controls["LeftForwardKey"]:
		ldrive(event)
	elif code == controls["LeftBackwardKey"]:
		lreverse(event)
	elif code == controls["LeftStrafeKey"]:
		lstrafe(event)
	elif code == controls["LeftFireKey"]:
		lfire(event)
	elif code == controls["RightForwardKey"]:
		rdrive(event)
	elif code == controls["RightBackwardKey"]:
		rreverse(event)
	elif code == controls["RightStrafeKey"]:
		rstrafe(event)
	elif code == controls["RightFireKey"]:
		rfire(event)

#event functions
func ldrive(event):
	if animation_player.get_current_animation() == "Idle":
		animation_player.play("MoveForward")
	if event.pressed == false:
		idle()

func lreverse(event):
	if animation_player.get_current_animation() == "Idle":
		animation_player.play("MoveBackward")
	if event.pressed == false:
		idle()

func lstrafe(event):
	if animation_player.get_current_animation() == "Idle":
		animation_player.play("StrafeLeft")
	if event.pressed == false:
		idle()

func lfire(event):
	animation_player.play("FireLeft")
	animation_player.connect("animation_finished", self, "Idle")
	animation_player.animation_set_next("FireLeft", "Idle")

func rdrive(event):
	if animation_player.get_current_animation() == "Idle":
		animation_player.play("MoveForward")
	if event.pressed == false:
		idle()
		
func rreverse(event):
	if animation_player.get_current_animation() == "Idle":
		animation_player.play("MoveBackward")
	if event.pressed == false:
		idle()
		
func rstrafe(event):
	if animation_player.get_current_animation() == "Idle":
		animation_player.play("StrafeRight")
	if event.pressed == false:
		idle()
		
func rfire(event):
	animation_player.play("FireRight")
	animation_player.connect("animation_finished", self, "Idle")
	animation_player.animation_set_next("FireRight", "Idle")
	
func idle():
	animation_player.play("Idle")
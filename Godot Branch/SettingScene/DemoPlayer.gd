extends KinematicBody

var SPEED = 0.05
var controls = {}				#holds keymapping
var axis_tolerance = 0.9		#helps with joystick drifting
var animation_player			#the animation controller
var player_action = "Idle"		#indicates player's last animation state, prevents loooping
var player_null_state			#used for determining idle state
var player_state = {			#indicates which keys are down
		"LForward" : false,
		"LBackward" : false,
		"RForward" : false,
		"RBackward" : false,
		"Left" : false,
		"Right" : false,
		"FireLeft" : false,
		"FireRight" : false,
		"SteerLeft" : false,
		"SteerRight" : false}
var engine
var leftBlaster
var rightBlaster


# Called when the node enters the scene tree for the first time.
func _ready():
	#get character variables
	animation_player = get_node("AnimationPlayer")
	engine = get_node("EngineSound")
	leftBlaster = get_node("LeftBlaster")
	rightBlaster = get_node("RightBlaster")
	
	#used to set idle state
	player_null_state = player_state.duplicate()
	
	#map keys to actions
	load_input_map()


#imports controls from ControlsMenu.gd
func load_input_map():
	controls = get_node("../ViewportContainer/Viewport/Control").controls.duplicate()


# Called with each input event
func _input(event):
	#TRANSLATE 
	#event to input code
	var code
	var axis = 0

	if event is InputEventKey:				#keyboard events
		code = event.scancode
	elif event is InputEventJoypadButton:	#joypad events
		code = event.button_index
	elif event is InputEventJoypadMotion:	#joypad events
		code = event.axis
		if event.axis_value > 0:
			axis = 1
		elif event.axis_value < 0:
			axis = -1
	else:									#other events
		return
		
	#convert code to value array that matched control dictionary
	#unknown bug: Arrays with same individual components != Array match
	#use string instead
	var inputValue= String([event.get_class(), code, axis])

	#SET STATE
	#state based on input code
	if inputValue == String(controls["LeftForwardKey"]):
		player_state["LForward"] = true
		player_state["SteerRight"] = true
		if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
			player_state["LForward"] = false
			player_state["SteerRight"] = false
		
	if inputValue == String(controls["LeftBackwardKey"]):
		player_state["LBackward"] = true
		player_state["SteerLeft"] = true
		if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
			player_state["LBackward"] = false
			player_state["SteerLeft"] = false
		
	#allow only one strafe event at any time
	if inputValue == String(controls["LeftStrafeKey"]) && !player_state["Right"]:
		player_state["Left"] = true
		if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
			player_state["Left"] = false
		
	#allow only one firing event at any time
	if inputValue == String(controls["LeftFireKey"]) && !player_state["FireRight"]:
		if event.is_pressed():
			player_state["FireLeft"] = true
	
	if inputValue == String(controls["RightForwardKey"]):
		player_state["RForward"] = true
		player_state["SteerLeft"] = true
		if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
			player_state["RForward"] = false
			player_state["SteerLeft"] = false
		
	if inputValue == String(controls["RightBackwardKey"]):
		player_state["RBackward"] = true
		player_state["SteerRight"] = true
		if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
			player_state["RBackward"] = false
			player_state["SteerRight"] = false
		
	#allow only one strafe event at any time
	if inputValue == String(controls["RightStrafeKey"]) && !player_state["Left"]:
		player_state["Right"] = true
		if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
			player_state["Right"] = false
	
	#allow only one firing event at any time
	if inputValue == String(controls["RightFireKey"]) && !player_state["FireLeft"]:
		if !event.is_pressed():
			player_state["FireRight"] = true


#Controls player's motion
func animatePlayer():
	# SET ANIMATION
	var currentAnimation = animation_player.get_current_animation()		#Used to determine completion of firing animation
	#Firing takes top priority
	#Do not play animation if already playing
	if currentAnimation != "FireLeft" && currentAnimation != "FireRight":
		if player_state["FireLeft"]:
			animation_player.play("FireLeft")
			player_action = "Firing"
			leftBlaster.play()
			player_state["FireLeft"] = false
		elif player_state["FireRight"]:
			animation_player.play("FireRight")
			player_action = "Firing"
			rightBlaster.play()
			player_state["FireRight"] = false
			
		#Handle movement animations
		elif player_state["LForward"] || player_state["RForward"]:
			if player_action != "MoveForward":
				animation_player.play("MoveForward")
				player_action = "MoveForward"
				engine.play()
		elif player_state["LBackward"] || player_state["RBackward"]:
			if player_action != "MoveBackward":
				animation_player.play("MoveBackward")
				player_action = "MoveBackward"
				engine.play()
		elif player_state["Left"]:
			if player_action != "StrafeLeft":
				animation_player.play("StrafeLeft")
				player_action = "StrafeLeft"
				engine.play()
		elif player_state["Right"]:
			if player_action != "StrafeRight":
				animation_player.play("StrafeRight")
				player_action = "StrafeRight"
				engine.play()
			
		#If not moving, idle
		elif player_null_state.values() == player_state.values(): 
			animation_player.play("Idle")
			player_action = "Idle"
			engine.stop()
	
	#MOVEMENT
	if player_state["LForward"] || player_state["RForward"]:
		move_and_collide(get_transform().basis.xform(Vector3(0, 0, SPEED)))	#transform based on local axis
	if player_state["LForward"] && player_state["RForward"]:
		move_and_collide(get_transform().basis.xform(Vector3(0, 0, SPEED)))	#double speed with same direction down
	if player_state["LBackward"] || player_state["RBackward"]:
		move_and_collide(get_transform().basis.xform(Vector3(0, 0, -SPEED)))
	if player_state["LBackward"] && player_state["RBackward"]:
		move_and_collide(get_transform().basis.xform(Vector3(0, 0, -SPEED)))	#double speed with same direction down
	if player_state["Left"]:
		move_and_collide(get_transform().basis.xform(Vector3(SPEED, 0, 0)))
	if player_state["Right"]:
		move_and_collide(get_transform().basis.xform(Vector3(-SPEED, 0, 0)))
	if player_state["SteerLeft"]:
		rotate_y(SPEED/2.5)
	if player_state["SteerRight"]:
		rotate_y(-SPEED/2.5)


func _on_AnimationPlayer_animation_finished(anim_name):
	#After firing animation completes, idle
	if anim_name == "FireLeft" || anim_name == "FireRight":
		animation_player.play("Idle")
		player_action = "Idle"


func _process(delta):
	animatePlayer()

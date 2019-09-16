extends KinematicBody

#player variables
var MAX_SPEED = .15
var MIN_SPEED = .05
var mass = 0
var MAX_MASS = 2000
var energy = 3000
var damaged = 0
var MAX_ENERGY = 3000
var MOVE_COST = 1
var FIRE_COST = 10
var RECOVERY_RATE = 50	#amount recovered per interval
var RECOVERY_SPEED = .3 #duration(seconds) between intervals
var gravity
var playerUI
var timeElapsed = 0

#control variables
var controls = {}				#holds keymapping
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
var PLAYER_BULLET = preload("res://Assets/PlayerBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#get animator controller
	animation_player = get_node("AnimationPlayer")
	
	#used to set idle state
	player_null_state = player_state.duplicate()
	
	#get/load scene variables
	gravity = get_parent().GRAVITY
	playerUI = get_node("../ViewportContainer/Viewport/PlayerUI")
	
	#map keys to actions
	load_input_map()


#imports controls from file
func load_input_map():
	var configFile = File.new()
	
	#if config file exists, load controls
	if configFile.open("user://controls.cfg", File.READ) == 0:
		controls = parse_json(configFile.get_line())
		configFile.close()
	#if config file does not exist, load default controls
	else:
		controls = default_controls.duplicate()


# Called with each input event
func _input(event):
	#TRANSLATE 
	#event to input code
	var code

	if event is InputEventKey:				#keyboard events
		code = event.scancode
	elif event is InputEventJoypadButton:	#joypad events
		code = event.button_index
	else:									#other events
		return

	#SET STATE
	#state based on input code
	if code == controls["LeftForwardKey"]:
		if event.is_pressed():
			player_state["LForward"] = true
			player_state["SteerRight"] = true
		else:
			player_state["LForward"] = false
			player_state["SteerRight"] = false
		
	if code == controls["LeftBackwardKey"]:
		if event.is_pressed():
			player_state["LBackward"] = true
			player_state["SteerLeft"] = true
		else:
			player_state["LBackward"] = false
			player_state["SteerLeft"] = false
		
	#allow only one strafe event at any time
	if code == controls["LeftStrafeKey"] && !player_state["Right"]:
		if event.is_pressed():
			player_state["Left"] = true
		else:
			player_state["Left"] = false
		
	#allow only one firing event at any time
	if code == controls["LeftFireKey"] && !player_state["FireRight"]:
		if !event.is_pressed():
			player_state["FireLeft"] = true
	
	if code == controls["RightForwardKey"]:
		if event.is_pressed():
			player_state["RForward"] = true
			player_state["SteerLeft"] = true
		else:
			player_state["RForward"] = false
			player_state["SteerLeft"] = false
		
	if code == controls["RightBackwardKey"]:
		if event.is_pressed():
			player_state["RBackward"] = true
			player_state["SteerRight"] = true
		else:
			player_state["RBackward"] = false
			player_state["SteerRight"] = false
		
	#allow only one strafe event at any time
	if code == controls["RightStrafeKey"] && !player_state["Left"]:
		if event.is_pressed():
			player_state["Right"] = true
		else:
			player_state["Right"] = false
	
	#allow only one firing event at any time
	if code == controls["RightFireKey"] && !player_state["FireLeft"]:
		if !event.is_pressed():
			player_state["FireRight"] = true


#Controls player's motion
func animatePlayer():
	# SET ANIMATION
	var currentAnimation = animation_player.get_current_animation()		#Used to determine completion of firing animation
	
	#Do not act if firing
	if currentAnimation != "FireLeft" && currentAnimation != "FireRight":
		#Handle firing action: top priority
		if player_state["FireLeft"] && energy > FIRE_COST:
			animation_player.play("FireLeft")
			player_action = "Firing"
			spawnProjectile($LeftSpawnBullet.global_transform)
			energy -= FIRE_COST
			player_state["FireLeft"] = false
		elif player_state["FireRight"] && energy > FIRE_COST:
			animation_player.play("FireRight")
			player_action = "Firing"
			spawnProjectile($RightSpawnBullet.global_transform)
			energy -= FIRE_COST
			player_state["FireRight"] = false
			
		#Handle movement animations
		elif player_state["LForward"] || player_state["RForward"]:
			if player_action != "MoveForward":		#checks to see if animation already playing
				animation_player.play("MoveForward")
				player_action = "MoveForward"
		elif player_state["LBackward"] || player_state["RBackward"]:
			if player_action != "MoveBackward":
				animation_player.play("MoveBackward")
				player_action = "MoveBackward"
		elif player_state["Left"]:
			if player_action != "StrafeLeft":
				animation_player.play("StrafeLeft")
				player_action = "StrafeLeft"
		elif player_state["Right"]:
			if player_action != "StrafeRight":
				animation_player.play("StrafeRight")
				player_action = "StrafeRight"
			
		#If no action being taken, idle
		elif player_null_state.values() == player_state.values(): 
			animation_player.play("Idle")
			player_action = "Idle"
	
	#PHYSICAL MOVEMENT
	#move only with enough energy, can move with 0 energy but takes damage.
	if energy > 0:
		var col_info #collision detection information
		#determine movement speed from mass carried
		var speed = ((MAX_MASS - mass)/MAX_MASS * (MAX_SPEED - MIN_SPEED)) + MIN_SPEED
		
		if player_state["LForward"] || player_state["RForward"]:
			col_info = move_and_collide(get_transform().basis.xform(Vector3(0, 0, speed)))	#transform based on local axis
			energy -= MOVE_COST
		if player_state["LForward"] && player_state["RForward"]:
	# warning-ignore:return_value_discarded
			move_and_collide(get_transform().basis.xform(Vector3(0, 0, speed)))	#double speed with same direction down
			energy -= MOVE_COST
		if player_state["LBackward"] || player_state["RBackward"]:
			col_info = move_and_collide(get_transform().basis.xform(Vector3(0, 0, -speed)))
			energy -= MOVE_COST
		if player_state["LBackward"] && player_state["RBackward"]:
	# warning-ignore:return_value_discarded
			move_and_collide(get_transform().basis.xform(Vector3(0, 0, -speed)))	#double speed with same direction down
			energy -= MOVE_COST
		if player_state["Left"]:
			col_info = move_and_collide(get_transform().basis.xform(Vector3(speed*2, 0, 0)))
			energy -= MOVE_COST
		if player_state["Right"]:
			col_info = move_and_collide(get_transform().basis.xform(Vector3(-speed*2, 0, 0)))
			energy -= MOVE_COST
		if player_state["SteerLeft"]:
			rotate_y(speed/2.5)
			energy -= MOVE_COST
		if player_state["SteerRight"]:
			rotate_y(-speed/2.5)
			energy -= MOVE_COST
			
		#COLLISION DETECTION
		if col_info:
			#if collider can be knocked back, knock it back
			if col_info.collider.has_method("knockback"):
				col_info.collider.knockback(mass + 1000, speed, col_info.normal)
			#if collider can be picked up, pick it up and add to mass
			if col_info.collider.has_method("pickup") && mass < MAX_MASS:
				col_info.collider.pickup()
				mass += 100


#adds damage taken to total damage taken
func damage(amount = 10):
	damaged += amount


#spawns a bullet
func spawnProjectile(proj_trans):
	var projectile = PLAYER_BULLET.instance()
	projectile.transform = proj_trans
	get_parent().add_child(projectile)


#Called each frame
func _process(delta):
	animatePlayer()
	
	#keep energy bar from displaying negative numbers
	#if try to use action when no energy, take damage
	if energy < 0:
		damage()
		energy = 0
	
	#recover some energy each second
	timeElapsed += delta
	if timeElapsed >= RECOVERY_SPEED:
		timeElapsed = 0
		#stop recovering at max
		if energy >= MAX_ENERGY:
			energy = MAX_ENERGY
		#recover slowly in damaged range
		elif energy > MAX_ENERGY - damaged:
			energy += RECOVERY_RATE/5
		else:
			energy += RECOVERY_RATE
	
	#account for gravity
# warning-ignore:return_value_discarded
	move_and_collide(get_transform().basis.xform(Vector3(0, -gravity, 0)))
	
	#update UI
	playerUI.updateUI(energy, mass, damaged)
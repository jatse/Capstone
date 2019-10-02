extends KinematicBody

#player variables
var MAX_SPEED = 0.08
var MIN_SPEED = 0.05
var mass = 0.0
var MAX_MASS = 2000.0
var energy = 1000
var damaged = 0
var MAX_ENERGY = 1000
var MOVE_COST = 1
var FIRE_COST = 10
var RECOVERY_RATE = 35	#amount recovered per interval
var RECOVERY_SPEED = .3 #duration(seconds) between intervals
var gravity
var playerUI
var timeElapsed = 0

#control variables
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

#audio variables
var engine
var leftblaster
var rightblaster
var outer
var pickup
var emergency

# Called when the node enters the scene tree for the first time.
func _ready():
	#get character variables
	animation_player = get_node("AnimationPlayer")
	engine = get_node("EngineSound")
	leftblaster = get_node("LeftBlasterSound")
	rightblaster = get_node("RightBlasterSound")
	outer = get_node("OuterSound")
	pickup = get_node("PickupSound")
	emergency = get_node("InternalSiren")
	
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
master func _input(event):
	#act only if the mech belongs to user
	if is_network_master():
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
			$"lt-boost".visible = true
			if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
				player_state["LForward"] = false
				player_state["SteerRight"] = false
				$"lt-boost".visible = false
			
		if inputValue == String(controls["LeftBackwardKey"]):
			player_state["LBackward"] = true
			player_state["SteerLeft"] = true
			$"lb-boost".visible = true
			if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
				player_state["LBackward"] = false
				player_state["SteerLeft"] = false
				$"lb-boost".visible = false
			
		#allow only one strafe event at any time
		if inputValue == String(controls["LeftStrafeKey"]) && !player_state["Right"]:
			player_state["Left"] = true
			$"rm-boost".visible = true
			if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
				player_state["Left"] = false
				$"rm-boost".visible = false
			
		#allow only one firing event at any time
		if inputValue == String(controls["LeftFireKey"]) && !player_state["FireRight"]:
			if event.is_pressed():
				player_state["FireLeft"] = true
		
		if inputValue == String(controls["RightForwardKey"]):
			player_state["RForward"] = true
			player_state["SteerLeft"] = true
			$"rt-boost".visible = true
			if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
				player_state["RForward"] = false
				player_state["SteerLeft"] = false
				$"rt-boost".visible = false
			
		if inputValue == String(controls["RightBackwardKey"]):
			player_state["RBackward"] = true
			player_state["SteerRight"] = true
			$"rb-boost".visible = true
			if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
				player_state["RBackward"] = false
				player_state["SteerRight"] = false
				$"rb-boost".visible = false
			
		#allow only one strafe event at any time
		if inputValue == String(controls["RightStrafeKey"]) && !player_state["Left"]:
			player_state["Right"] = true
			$"lm-boost".visible = true
			if !event.is_pressed() || (event is InputEventJoypadMotion && abs(event.axis_value) < axis_tolerance):
				player_state["Right"] = false
				$"lm-boost".visible = false
		
		#allow only one firing event at any time
		if inputValue == String(controls["RightFireKey"]) && !player_state["FireLeft"]:
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
			playAudio(leftblaster)
		elif player_state["FireRight"] && energy > FIRE_COST:
			animation_player.play("FireRight")
			player_action = "Firing"
			spawnProjectile($RightSpawnBullet.global_transform)
			energy -= FIRE_COST
			player_state["FireRight"] = false
			playAudio(rightblaster)
			
		#Handle movement animations
		elif player_state["LForward"] || player_state["RForward"]:
			if player_action != "MoveForward":		#checks to see if animation already playing
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
			
		#If no action being taken, idle
		elif player_null_state.values() == player_state.values(): 
			animation_player.play("Idle")
			player_action = "Idle"
			engine.stop()
	
	#PHYSICAL MOVEMENT
	#move only with enough energy, can move with 0 energy but takes damage.
	if energy > 0:
		var col_info #collision detection information
		#determine movement speed from mass carried
		var speed = (((MAX_MASS - mass)/MAX_MASS) * MAX_SPEED) + MIN_SPEED
		
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
				col_info.collider.knockback(mass + 1000, speed, col_info.position - self.transform.origin)
			#if collider can be picked up, pick it up and add to mass
			if col_info.collider.has_method("pickup") && mass < MAX_MASS:
				col_info.collider.pickup()
				pickup.play()
				mass += randi()%51+50
				if mass > MAX_MASS:
					mass = MAX_MASS


#adds damage taken to total damage taken
func damage(amount = 10):
	#only affect UI if it's your character
	if is_network_master():
		playerUI.flicker()
	damaged += amount
	#lose cargo when damaged
	mass -= int(amount)
	#check min mass
	if mass < 0:
		mass = 0


#knocks character back and does damage
func knockback(weight, velocity, normal):
	playAudio(outer)
	var force = weight * velocity * 3		#adjust last number to change knock back intensity
	var knock_vector = Vector3(normal.x * force, 0, normal.z * force)
	move_and_slide(get_transform().basis.xform(knock_vector))
	damage(int(force/30))


#spawns a bullet
func spawnProjectile(proj_trans):
	var projectile = PLAYER_BULLET.instance()
	projectile.transform = proj_trans
	get_parent().add_child(projectile)


func playAudio(audioPlayer):
	#blaster sounds
	if audioPlayer == leftblaster || audioPlayer == rightblaster:
		#load random track
		match randi()%2:
			0:
				audioPlayer.stream = load("res://Assets/sounds/fire_laser.wav")
			1:
				audioPlayer.stream = load("res://Assets/sounds/fire_laser2.wav")
		audioPlayer.play()
		
	#outer noises
	if audioPlayer == outer:
		#load random track
		match randi()%2:
			0:
				audioPlayer.stream = load("res://Assets/sounds/player_crash.wav")
			1:
				audioPlayer.stream = load("res://Assets/sounds/player_crash2.wav")
	audioPlayer.play()


#Called each frame
func _process(delta):
	animatePlayer()
	
	#keep energy bar from displaying negative numbers
	#if try to use action when no energy, take damage
	if energy < 0:
		damage()
		energy = 0
	
	#recover some energy each recover speed interval
	timeElapsed += delta
	if timeElapsed >= RECOVERY_SPEED:
		timeElapsed = 0
		#recover slowly in damaged range
		if energy > MAX_ENERGY - damaged:
			energy += RECOVERY_RATE/5
		else:
			energy += RECOVERY_RATE
	#stop recovering at max
	if energy >= MAX_ENERGY:
		energy = MAX_ENERGY
		
	#play warning sound if energy below 100
	if energy < 100 && !emergency.is_playing():
		emergency.play()
	elif energy > 100 && emergency.is_playing():
		emergency.stop()
	
	#account for gravity
# warning-ignore:return_value_discarded
	move_and_collide(get_transform().basis.xform(Vector3(0, -gravity, 0)))
	
	#update UI
	#only affect UI if it's your character
	if is_network_master():
		playerUI.updateUI(energy)
		#update other intances of yourself on network
		rpc_unreliable("syncPlayer", self.transform, mass, player_state)


#called remotely by master to update position, mass, and animation
puppet func syncPlayer(orientation, new_mass, current_state):
	self.transform = orientation
	mass = new_mass
	player_state = current_state
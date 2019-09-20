extends KinematicBody

#AI player variables
var MAX_SPEED = 0.10
var MIN_SPEED = 0.05
var mass = 0.0
var MAX_MASS = 2000.0
var damaged = 0
var gravity
var timeElapsed = 0

#control variables
var animation_player			#the animation controller
var AI_state = "normal"		#determines AI program
var space_state					#gets space for ray tracing
var ray_detector
var forward_detect = "none"
var area_detector
var detect_count
var player_action = "Idle"		#indicates player's last animation state, prevents loooping
var player_null_state			#used for determining idle state
var player_state = {			#indicates which actions are active
		"Forward" : false,
		"Backward" : false,
		"Left" : false,
		"Right" : false,
		"FireLeft" : false,
		"FireRight" : false,
		"SteerLeft" : false,
		"SteerRight" : false}
var PLAYER_BULLET = preload("res://Assets/PlayerBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#get animator controller
	animation_player = get_node("AnimationPlayer")
	
	#used to set idle state
	player_null_state = player_state.duplicate()
	
	#get/load scene variables
	gravity = get_parent().GRAVITY
	
	#get variables for ray cast and sensors
	space_state = get_world().direct_space_state
	ray_detector = get_node("RayCast")
	ray_detector.set_enabled(true)
	ray_detector.set_cast_to(Vector3(0, 0, 20))	#ray limit, set to a relative point 
	area_detector = get_node("areaDetector")


# Determines what AI action to take
func ai_process():
	#clear last command
	player_state = player_null_state.duplicate()

	#REGULAR PROGRAM: search and gather gems
	if AI_state == "normal":
		#if something in the area ...
		if detect_count > 1:
			#rotate until in sight ...
			if forward_detect == "none" || forward_detect == "wall":
				player_state["SteerRight"] = true
			#if gem detected, stop turning and go forward to collect
			elif forward_detect == "gem":
				player_state["Forward"] = true
			#if enemy spotted, try to destroy
			elif forward_detect == "enemy":
				var chance = randi()%10	#a 2/modulo divisor chance to shoot
				if chance == 0:
					player_state["FireLeft"] = true
				elif chance == 1:
					player_state["FireRight"] = true
				else:
					player_state["Forward"] = true
		#if nothing in area
		else:
			#move if path clear, occasionally side step
			if forward_detect == "none":
				if randi()%10 == 0:
					player_state["Right"] = true
				else:
					player_state["Forward"] = true
			#otherwise rotate
			else:
				player_state["SteerRight"] = true
				
	#EMERGENCY PROGRAM: escape until alone
	else:
		if detect_count > 1:
			if forward_detect == "none":
				if randi()%10 == 0:
					player_state["Left"] = true
				else:
					player_state["Forward"] = true
			#otherwise rotate
			else:
				player_state["SteerLeft"] = true
		else:
			AI_state = "normal"


#Controls player's motion
func animatePlayer():
	# SET ANIMATION
	var currentAnimation = animation_player.get_current_animation()		#Used to determine completion of firing animation
	
	#Do not act if firing
	if currentAnimation != "FireLeft" && currentAnimation != "FireRight":
		#Handle firing action: top priority
		if player_state["FireLeft"]:
			animation_player.play("FireLeft")
			player_action = "Firing"
			spawnProjectile($LeftSpawnBullet.global_transform)
			player_state["FireLeft"] = false
		elif player_state["FireRight"]:
			animation_player.play("FireRight")
			player_action = "Firing"
			spawnProjectile($RightSpawnBullet.global_transform)
			player_state["FireRight"] = false
			
		#Handle movement animations
		elif player_state["Forward"]:
			if player_action != "MoveForward":		#checks to see if animation already playing
				animation_player.play("MoveForward")
				player_action = "MoveForward"
		elif player_state["Backward"]:
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
	var col_info #collision detection information
	#determine movement speed from mass carried
	var speed = (((MAX_MASS - mass)/MAX_MASS) * MAX_SPEED) + MIN_SPEED
	
	if player_state["Forward"]:
		col_info = move_and_collide(get_transform().basis.xform(Vector3(0, 0, speed)))	#transform based on local axis
	if player_state["Backward"]:
		col_info = move_and_collide(get_transform().basis.xform(Vector3(0, 0, -speed)))
	if player_state["Left"]:
		col_info = move_and_collide(get_transform().basis.xform(Vector3(speed*2, 0, 0)))
	if player_state["Right"]:
		col_info = move_and_collide(get_transform().basis.xform(Vector3(-speed*2, 0, 0)))
	if player_state["SteerLeft"]:
		rotate_y(speed)
	if player_state["SteerRight"]:
		rotate_y(-speed)
		
	#COLLISION DETECTION
	if col_info:
		#if collider can be knocked back, knock it back
		if col_info.collider.has_method("knockback"):
			col_info.collider.knockback(mass + 1000, speed, col_info.position - self.transform.origin)
		#if collider can be picked up, pick it up and add to mass
		if col_info.collider.has_method("pickup") && mass < MAX_MASS:
			col_info.collider.pickup()
			mass += randi()%101+100
			if mass > MAX_MASS:
					mass = MAX_MASS


#adds damage taken to total damage taken
func damage(amount = 10):
	damaged += amount
	#lose cargo when damaged
	mass -= int(amount)
	if mass < 0:
		mass = 0
	AI_state = "danger"


#spawns a bullet
func spawnProjectile(proj_trans):
	var projectile = PLAYER_BULLET.instance()
	projectile.transform = proj_trans
	get_parent().add_child(projectile)


#knocks character back and does damage
func knockback(weight, velocity, normal):
	var force = weight * velocity * 3		#adjust last number to change knock back intensity
	var knock_vector = Vector3(normal.x * force, 0, normal.z * force)
	move_and_slide(get_transform().basis.xform(knock_vector))
	damage(int(force/30))


#called each frame on physics step
#uses front sensor to determine what is closest in front
func _physics_process(delta):

	#update front sensor
	#check for closest object
	if ray_detector.is_colliding():
		var ray_info
		ray_info = ray_detector.get_collider()
		
		if ray_info.has_method("pickup"):
			forward_detect = "gem"
		elif ray_info.has_method("knockback"):
			forward_detect = "enemy"
		elif global_transform.origin.distance_to(ray_detector.get_collision_point()) < 10:
			forward_detect = "wall"
		else:
			forward_detect = "none"
	else:
		forward_detect = "none"
		

	#update area sensor
	detect_count = area_detector.get_overlapping_bodies().size()

#Called each frame
func _process(delta):
	ai_process()
	animatePlayer()
	
	#track time elapsed
	timeElapsed += delta
	
	#account for gravity
# warning-ignore:return_value_discarded
	move_and_collide(get_transform().basis.xform(Vector3(0, -gravity, 0)))
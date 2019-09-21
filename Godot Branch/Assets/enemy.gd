extends KinematicBody

var health = 18
var state = "idle"
var gravity
var animation_player
var dieTime = 0
var waitTime = 0
var GEM = preload("res://Assets/gem.tscn")
var voice

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = get_parent().GRAVITY
	#get character variables
	animation_player = get_node("AnimationPlayer")
	voice = get_node("voiceSound")


#adds damage taken to total damage taken
func damage(amount = 1):
	health -= amount
	if dieTime == 0:
		animation_player.play("Hit")
		playAudio("hit")
	state = "stunned"
	waitTime = 1.5


#knocks character back and does damage
func knockback(weight, velocity, normal):
	playAudio("knock")
	var force = weight * velocity * 3		#adjust last number to change knock back intensity
	var knock_vector = Vector3(normal.x * force, 0, normal.z * force)
	move_and_slide(get_transform().basis.xform(knock_vector))
	damage(force/30)


#Plays audio depending on action
func playAudio(action):
	if action == "hit":
		match randi()%2:
			0:
				voice.stream = load("res://Assets/sounds/monster_hit.wav")
			1:
				voice.stream = load("res://Assets/sounds/monster_hit2.wav")
		
	if action == "knock":
		voice.stream = load("res://Assets/sounds/player_hit.wav")
		
	if action == "die":
		voice.stream = load("res://Assets/sounds/monster_die.wav")
				
	voice.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#account for gravity
# warning-ignore:return_value_discarded
	move_and_collide(get_transform().basis.xform(Vector3(0, -gravity, 0)))

	#account for death
	#if health just dropped to zero, play dying ainmation
	if health <= 0 && dieTime == 0:
		playAudio("die")
		animation_player.play("Die")
	#allow dying animation to complete
	if health <= 0:
		dieTime += delta
	#remove after death animation
	if dieTime >= 1:
		var gem = GEM.instance()
		gem.transform = self.transform
		get_parent().add_child(gem)
		queue_free()
		
	#ENEMY AI
	if waitTime <= 0 && dieTime == 0:
		#set time till next action
		waitTime = randi()%4+1
		match randi()%4:
			0:	#WAIT
				state = "idle"
				animation_player.play("Idle -loop")
			1:	#WALK
				state = "walk"
				animation_player.play("Walking")
			2:	#ROTATE LEFT
				state = "rotateL"
			3:	#ROTATE RIGHT
				state = "rotateR"
	elif state == "walk":
		#walk forward
		move_and_collide(get_transform().basis.xform(Vector3(0, 0, 0.08)))
		waitTime -= delta
	elif state == "rotateL":
		rotate_y(0.01)
		waitTime -= delta
	elif state == "rotateR":
		rotate_y(-0.01)
		waitTime -= delta
	else:
		#waiting for next decision
		waitTime -= delta
		

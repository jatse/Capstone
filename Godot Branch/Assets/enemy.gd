extends KinematicBody

var health = 10
var state = "idle" #determines speed of action
var gravity
var animation_player
var dieTime = 0
var waitTime = 0
var GEM = preload("res://Assets/gem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = get_parent().GRAVITY
	#get animator controller
	animation_player = get_node("AnimationPlayer")


#adds damage taken to total damage taken
func damage(amount = 1):
	health -= amount


#knocks character back and does damage
func knockback(weight, speed, normal):
	var force = weight * speed
	print(force)
	move_and_slide(get_transform().basis.xform(-normal * force))
	damage(force/10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#account for gravity
# warning-ignore:return_value_discarded
	move_and_collide(get_transform().basis.xform(Vector3(0, -gravity, 0)))

	#account for death
	#if health just dropped to zero, play dying ainmation
	if health <= 0 && dieTime == 0:
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
	if waitTime <= 0:
		#set time for next decision
		waitTime = randi()%6+1
		#WAIT
		#WALK
		#ROTATE
		
	else:
		#waiting for next decision
		waitTime -= delta
		

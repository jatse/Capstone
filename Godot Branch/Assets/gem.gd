extends KinematicBody

var gravity

func pickup():
	queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = get_parent().GRAVITY


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#account for gravity
# warning-ignore:return_value_discarded
	move_and_collide(get_transform().basis.xform(Vector3(0, -gravity, 0)))
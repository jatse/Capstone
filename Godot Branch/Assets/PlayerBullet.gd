extends KinematicBody


var SPEED = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var col_info = move_and_collide(get_transform().basis.xform(Vector3(0, 0, SPEED)))
	
	#check for collision
	if col_info:
		#if collide, create sparks and remove
		get_parent().spawnSparks(self.transform)
		queue_free()
extends KinematicBody

var SPARKS = preload("res://Assets/Sparks.tscn")
var SPEED = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var col_info = move_and_collide(get_transform().basis.xform(Vector3(0, 0, SPEED)))
	
	#check for collision
	if col_info:
		#damage colliding object
		if col_info.collider.has_method("damage"):
			col_info.collider.damage()
			
		#create sparks and remove
		var sparks = SPARKS.instance()
		sparks.transform = self.transform
		get_parent().add_child(sparks)
		queue_free()
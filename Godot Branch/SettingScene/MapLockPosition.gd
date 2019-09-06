extends StaticBody

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node("../../DemoPlayer")
	var playerLoc = get_node("../../DemoPlayer").get_global_transform().origin
	
	print(playerLoc)
	if playerLoc.x > 2:
		player.translate(Vector3(4, 0, 0))
	if playerLoc.x < -2:
		player.translate(Vector3(-4, 0, 0))
	if playerLoc.z > 2:
		player.translate(Vector3(0, 0, 4))
	if playerLoc.z < -2:
		player.translate(Vector3(0, 0, -4))

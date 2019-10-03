extends Area

var timeElapsed = 0
var spawnTime = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#if not the server, delete self
	if !get_tree().is_network_server():
		queue_free()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeElapsed += delta
	#chance to spawn evey 3 seconds
	if timeElapsed > spawnTime:
		spawnTime = randi()%6+1
		timeElapsed = 0
		#determine if no player or enemy in spawn zone
		if get_overlapping_bodies().empty():
			#call the game's spawnEnemy function
			get_parent().spawnEnemy(self.transform)
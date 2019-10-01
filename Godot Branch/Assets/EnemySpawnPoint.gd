extends Area

var timeElapsed = 0
var ENEMY = preload("res://Assets/enemy.tscn")
var sceneRoot
var spawnTime = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	sceneRoot = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeElapsed += delta
	#chance to spawn evey 3 seconds
	if timeElapsed > spawnTime:
		spawnTime = randi()%6+1
		timeElapsed = 0
		#determine if no player or enemy in spawn zone
		if get_overlapping_bodies().empty():
			spawnEnemy()

func spawnEnemy():
	var enemy = ENEMY.instance()
	enemy.transform = self.transform
	sceneRoot.call_deferred("add_child", enemy)
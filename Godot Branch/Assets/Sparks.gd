extends Spatial

var timeElapsed
var explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	timeElapsed = 0
	explosion = get_node("explodeSound")
	explosion.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeElapsed += delta
	if timeElapsed > .2:
		queue_free()

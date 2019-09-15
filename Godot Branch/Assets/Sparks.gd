extends Spatial

var timeElapsed

# Called when the node enters the scene tree for the first time.
func _ready():
	timeElapsed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeElapsed += delta
	if timeElapsed > .2:
		queue_free()

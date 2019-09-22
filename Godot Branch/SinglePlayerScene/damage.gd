extends Sprite

var timeElapsed = 0

func _process(delta):
	if self.visible == true:
		timeElapsed += delta
		if timeElapsed > 0.5:
			timeElapsed = 0
			self.visible = false
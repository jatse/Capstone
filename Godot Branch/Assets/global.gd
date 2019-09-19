extends Node

var loader
var root
var loading_screen = preload("res://LoadingScreen.tscn")

func _ready():
	root = get_tree().get_root()


#Handle loading and scene switching
func gotoScene(path):
	#get loader
	loader = ResourceLoader.load_interactive(path)
	#start polling. see _process
	set_process(true)
	#delete current scene
	root.get_child(root.get_child_count() - 1).queue_free()
	#load loading screen
	root.add_child(loading_screen.instance())

#polling process
func _process(delta):
	if loader == null:
		#stop if loader stops
		set_process(false)
		return
		
	#minimum wait time per frame. wait for 1/10 of a second; blocking
	var currentTime = OS.get_ticks_msec()
	while OS.get_ticks_msec() < currentTime + 100:
		#poll loader
		var load_status = loader.poll()
		
		#check loading status
		#load finished case
		if load_status == ERR_FILE_EOF:
			var next_scene = loader.get_resource()
			loader = null
			#remove loading screen
			root.get_child(root.get_child_count() - 1).queue_free()
			#instance loaded scene in root node
			root.add_child(next_scene.instance())
			break
		#still loading case
		elif load_status == OK:
			#get progress
			var progress = float(loader.get_stage()) / loader.get_stage_count()
			root.get_child(root.get_child_count() - 1).get_node("ProgressBar").set_value(progress)
		else:
			break
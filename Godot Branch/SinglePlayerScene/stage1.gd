extends Spatial

#Scene variables
# warning-ignore:unused_class_variable
var GRAVITY = 1
var player
var ai_green
var ai_blue
var ai_yellow
var green_skin = preload("res://Assets/green_skin.tres")
var blue_skin = preload("res://Assets/blue_skin.tres")
var yellow_skin = preload("res://Assets/yellow_skin.tres")

#called on load
func _ready():
	#get players
	player = get_node("Player")
	ai_green = get_node("AIPlayer_green")
	ai_blue = get_node("AIPlayer_blue")
	ai_yellow = get_node("AIPlayer_yellow")
	
	#make ai players  match namesake
	get_node("AIPlayer_green/Armature/player").set_surface_material(0, green_skin)
	get_node("AIPlayer_blue/Armature/player").set_surface_material(0, blue_skin)
	get_node("AIPlayer_yellow/Armature/player").set_surface_material(0, yellow_skin)


#called when game ends
func end_game():
	#save scores to global
	get_node("/root/global").scores = [player.mass, ai_green.mass, ai_blue.mass, ai_yellow.mass]
	#load results screen
	get_node("/root/global").gotoScene("res://SinglePlayerScene/ResultScreen.tscn")
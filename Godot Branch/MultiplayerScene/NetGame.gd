extends Spatial

var GRAVITY = 1
var mech = preload("res://Assets/NetPlayer.tscn")
var colorskins = [preload("res://Assets/green_skin.tres"), 
				  preload("res://Assets/blue_skin.tres"),
				  preload("res://Assets/yellow_skin.tres")]

# Called when the node enters the scene tree for the first time.
func _ready():
	#spawn self
	var player = mech.instance()
	player.set_name(str(get_tree().get_network_unique_id()))
	player.set_network_master(get_tree().get_network_unique_id())
	add_child(player)
	
	#spawn other players
	for id in Server.playerIDs:
		var other_player = mech.instance()
		other_player.set_name(str(id))
		other_player.set_network_master(id)
		add_child(other_player)
		
	#set proper camera
	get_node(str(get_tree().get_network_unique_id())).get_node("Camera").current = true
	
	#if server set the location of the players
	if get_tree().is_network_server():
		#set self position
		get_node(str(get_tree().get_network_unique_id())).transform = $PlayerSpawn3.transform
		rpc("init_character", get_tree().get_network_unique_id(), $PlayerSpawn3.transform)
		
		#set other position
		var spawnPosition = 0
		for id in Server.playerIDs:
			get_node(str(id)).transform = get_node("PlayerSpawn" + str(spawnPosition)).transform
			#also set color
			get_node(str(id) + "/Armature/player").set_surface_material(0, colorskins[spawnPosition])
			#sync positions
			rpc("init_character", id, get_node(str(id)).transform, spawnPosition)
			
			spawnPosition += 1

#Called by server to sync position and colors
remote func init_character(playerID, playerTransform, colorNumber = null):
	get_node(str(playerID)).transform = playerTransform
	if colorNumber != null:
		get_node(str(playerID) + "/Armature/player").set_surface_material(0, colorskins[colorNumber])
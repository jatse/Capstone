extends Node

var playerIDs = []
var playerCount = 1
var PORT = 8888
var MAX_PLAYERS = 4
var peer

func _ready():
	#connect signals to functions
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _player_connected(id):
	print("player connected to server")
	#add player id to global server info. playerIDs is an array.
	rpc_id(id, "addPlayer", get_tree().get_network_unique_id())

remote func addPlayer(id):
	Server.playerIDs.push_back(id)
	Server.playerCount += 1

func createServer():
	#create host server
	peer = NetworkedMultiplayerENet.new()
	var host_status = peer.create_server(PORT, MAX_PLAYERS)
	if host_status != OK:
		print("Couldn't create server")
		return false
	else:
		get_tree().set_network_peer(peer)
		return true

func createClient(ipAddr):
	peer = NetworkedMultiplayerENet.new()
	#join server at inputted address
	var peer_status = peer.create_client(ipAddr, PORT)
	if peer_status != OK:
		print("Couldn't connect to server")
	else:
		get_tree().set_network_peer(peer)
		return true

func clear_server():
	if peer != null:
		peer.close_connection()
	get_tree().set_network_peer(null)
	#reset server variable
	Server.playerCount = 1
	Server.playerIDs = []
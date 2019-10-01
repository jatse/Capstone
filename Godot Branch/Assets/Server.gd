extends Node

var peer
var SERVER_PORT = 8888
var players = {}
var playerCount = 0

#connect network signals to functions
func _ready():
    get_tree().connect("network_peer_connected", self, "addPlayer")
    get_tree().connect("network_peer_disconnected", self, "removePlayer")
    get_tree().connect("connected_to_server", self, "onConnect")
    get_tree().connect("connection_failed", self, "onConnectFail")
    get_tree().connect("server_disconnected", self, "onServerDisconnect")

#host server on this device
func startServer():
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, 4)
	get_tree().set_network_peer(peer)


#join server at given IP address
func joinServer(ipAddress):
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ipAddress, SERVER_PORT) 
	get_tree().set_network_peer(peer)


func addPlayer(player_id):
	print("player added")
	playerCount += 1
	players[player_id] = 0


func removePlayer(player_id):
	print("player removed")
	playerCount += 1
	players.erase(player_id)


func onConnect():
	print("player connected")
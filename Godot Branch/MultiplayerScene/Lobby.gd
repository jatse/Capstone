extends Node2D

var PORT = 8888
var MAX_PLAYERS = 4

func _ready():
	#default the ip address to local machine
	$LobbyContainer/NetworkConfig/NetworkAddress.text = IP.get_local_addresses()[0]
	
	#connect signals to functions
	get_tree().connect("network_peer_connected", self, "_player_connected")
	
func _player_connected(id):
	print("player connected to server")
	#add player id to global server info. playerIDs is an array.
	rpc_id(id, "addPlayer", get_tree().get_network_unique_id())

func _on_HostButton_pressed():
	print("now hosting server")
	#create host server
	var host = NetworkedMultiplayerENet.new()
	var host_status = host.create_server(PORT, MAX_PLAYERS)
	if host_status != OK:
		print("Couldn't create server")
	else:
		#reset ip address to local address and disable fields
		$LobbyContainer/NetworkConfig/NetworkAddress.text = IP.get_local_addresses()[0]
		$LobbyContainer/NetworkConfig/NetworkAddress.readonly = true
		$LobbyContainer/LobbyControl/HostButton.disabled = true
		$LobbyContainer/LobbyControl/JoinButton.disabled = true
		#allow start button to play with AIs
		$LobbyContainer/LobbyControl/StartButton.disabled = false
		get_tree().set_network_peer(host)

func _on_JoinButton_pressed():
	print("joining server")
	var peer = NetworkedMultiplayerENet.new()
	#join server at inputted address
	var peer_status = peer.create_client($LobbyContainer/NetworkConfig/NetworkAddress.text, PORT)
	if peer_status != OK:
		print("Couldn't connect to server")
	else:
		#disable fields
		$LobbyContainer/NetworkConfig/NetworkAddress.readonly = true
		$LobbyContainer/LobbyControl/HostButton.disabled = true
		$LobbyContainer/LobbyControl/JoinButton.disabled = true
		get_tree().set_network_peer(peer)		

remote func addPlayer(id):
	Server.playerIDs.push_back(id)
	Server.playerCount += 1

#start game for everyone on button press
func _on_StartButton_pressed():
	rpc("startGame")
	
#remotely called from host to start game
remotesync func startGame():
	var game = preload("res://MultiplayerScene/NetGame.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
	
#updates UI
func _process(delta):
	$LobbyContainer/LobbyLabel/PlayerCount.text = str(Server.playerCount)

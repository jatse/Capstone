extends Node2D

func _ready():
	#default the ip address to local machine
	$LobbyContainer/NetworkConfig/NetworkAddress.text = IP.get_local_addresses()[0]
	
	#reset server state
	Server.clear_server()

func _on_HostButton_pressed():
	if Server.createServer():
		#reset ip address to local address and disable fields
		$LobbyContainer/NetworkConfig/NetworkAddress.text = IP.get_local_addresses()[0]
		$LobbyContainer/NetworkConfig/NetworkAddress.readonly = true
		$LobbyContainer/LobbyControl/HostButton.disabled = true
		$LobbyContainer/LobbyControl/JoinButton.disabled = true
		#allow start button to play current players
		$LobbyContainer/LobbyControl/StartButton.disabled = false

func _on_JoinButton_pressed():
	if Server.createClient($LobbyContainer/NetworkConfig/NetworkAddress.text):
		#disable fields
		$LobbyContainer/NetworkConfig/NetworkAddress.readonly = true
		$LobbyContainer/LobbyControl/HostButton.disabled = true
		$LobbyContainer/LobbyControl/JoinButton.disabled = true

#start game for everyone on button press
func _on_StartButton_pressed():
	get_tree().set_refuse_new_network_connections(true)
	rpc("startGame")
	
#remotely called from host to start game
remotesync func startGame():
	var game = preload("res://MultiplayerScene/NetGame.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
	
#updates UI
func _process(delta):
	$LobbyContainer/LobbyLabel/PlayerCount.text = str(Server.playerCount)

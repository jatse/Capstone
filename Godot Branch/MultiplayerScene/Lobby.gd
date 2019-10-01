extends Node2D

var serverController
var lobbyController
var networkController

# Called when the node enters the scene tree for the first time.
func _ready():
	serverController = get_node("/root/Server")
	lobbyController = $LobbyContainer/LobbyControl
	networkController = $LobbyContainer/NetworkConfig
	
	#set default address to current device
	networkController.get_node("NetworkAddress").text = IP.get_local_addresses()[0]

	
#host a server
func _on_HostButton_pressed():
	#reset the ip address display to local address and allocate
	networkController.get_node("NetworkAddress").text = IP.get_local_addresses()[0]
	
	#disable the contol area
	lobbyControllerDisable(true)
	
	#start server
	serverController.startServer()


#join a server
func _on_JoinButton_pressed():
	#disable the contol area
	lobbyControllerDisable(true)
	
	#join server at entered IIP address
	serverController.joinServer(networkController.get_node("NetworkAddress").text)


#toggles the editability of the lobby controls
#accepts boolean: true to disable, false to enable
func lobbyControllerDisable(state):
	networkController.get_node("NetworkAddress").readonly = state
	lobbyController.get_node("HostButton").disabled = state
	lobbyController.get_node("JoinButton").disabled = state


#updates player count
func updatePlayerCount(count):
	$LobbyContainer/LobbyLabel/PlayerCount.text = str(count)

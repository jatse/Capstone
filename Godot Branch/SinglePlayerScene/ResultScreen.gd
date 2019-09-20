extends Control

var player1
var player2
var player3
var player4
var scores
var win_order = [] #player#, score, player#, score ....
var timeElapsed = 0
var bar_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#get UI elements
	player1 = get_node("VBoxContainer/PlayerStats/Player1/P1Bar")
	player2 = get_node("VBoxContainer/PlayerStats/Player2/P2Bar")
	player3 = get_node("VBoxContainer/PlayerStats/Player3/P3Bar")
	player4 = get_node("VBoxContainer/PlayerStats/Player4/P4Bar")
	
	#retrieve scores
	scores = get_node("/root/global").scores
	
	
func _process(delta):
	timeElapsed += delta
	
	#blocking for animation
	if timeElapsed >= 0.01 && win_order.size() < 8:
		#reset clock
		timeElapsed = 0
		#increment bar
		bar_value += 24 - (win_order.size() * 3)
		
		if !win_order.has("1"):
			if bar_value >= scores[0]:
				player1.set_value(scores[0])
				win_order.push_front(scores[0])
				win_order.push_front("1")
			else:
				player1.set_value(bar_value)
				
		if !win_order.has("2"):
			if bar_value >= scores[1]:
				player2.set_value(scores[1])
				win_order.push_front(scores[1])
				win_order.push_front("2")
			else:
				player2.set_value(bar_value)
				
		if !win_order.has("3"):
			if bar_value >= scores[2]:
				player3.set_value(scores[2])
				win_order.push_front(scores[2])
				win_order.push_front("3")
			else:
				player3.set_value(bar_value)
				
		if !win_order.has("4"):
			if bar_value >= scores[3]:
				player4.set_value(scores[3])
				win_order.push_front(scores[3])
				win_order.push_front("4")
			else:
				player4.set_value(bar_value)
				
		if win_order.size() == 8:
			show_winner()


func show_winner():
	var placement = -1
	var title = ["1st", "2nd", "3rd", "4th"]
	var lastPoint = -99
	
	#for each player ...
	for i in range(4):
		#if tied with previous person, give same placement, and increment
		if win_order[(2*i + 1)] == lastPoint:
			get_node("VBoxContainer/PlayerStats/Player" + str(win_order[2*i]) + "/placement").set_text(title[placement])
		#otherwise increment placement and assign
		else:
			placement += 1
			get_node("VBoxContainer/PlayerStats/Player" + str(win_order[2*i]) + "/placement").set_text(title[placement])
			lastPoint = win_order[(2*i + 1)] 
			
	#make accept button visible
	get_node("VBoxContainer/ControlPanel/CenterContainer/AcceptButton").visible = true
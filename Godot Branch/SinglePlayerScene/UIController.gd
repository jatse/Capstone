extends Control

var gameClock
var clockDisplay
var energyLevel
var massMeter
var overheatCover
var overloadCover
var ticker
var timeElapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Start the game timer
	gameClock = get_node("Timer")
	gameClock.start(300)
	clockDisplay = get_node("TimerLabel")
	
	#define UI elements
	energyLevel = get_node("EnergyLevel")
	massMeter = get_node("MassMeter")
	overheatCover = get_node("overheatWarning")
	overloadCover = get_node("overloadWarning")
	ticker = get_node("AudioStreamPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	#update clock display
	var minutes = int(gameClock.get_time_left()/60)
	#pad zero if single digit minutes remain
	if minutes < 10:
		minutes = str("0" + str(minutes))
		
	var seconds = int(gameClock.get_time_left()) % 60
	#pad zero if single digit seconds remain
	if seconds < 10:
		seconds = "0" + str(seconds)
	clockDisplay.set_text(str(minutes) + ":" + str(seconds))
	
	if gameClock.get_time_left() <= 32 && !gameClock.is_stopped():
		timeElapsed += delta
		if timeElapsed >= 1:
			timeElapsed = 0
			ticker.play()
	
	#end game if time is up
	if gameClock.get_time_left() <= 0:
		gameClock.stop()
		#viewport > container > stage.end_game
		get_parent().get_parent().get_parent().end_game()


func flicker():
	get_node("damage").visible = true

#sets UI text
func updateUI(energy, mass):
	#update meters
	energyLevel.set_value(energy)
	massMeter.set_text(str(mass))
	
	#enable warnings
	if energy < 100:
		overheatCover.set_visible(false)
	else:
		overheatCover.set_visible(true)
		
	if mass >= 2000:
		overloadCover.set_visible(false)
	else:
		overloadCover.set_visible(true)
	
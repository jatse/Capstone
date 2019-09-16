extends Control

var gameClock
var clockDisplay
var energyLevel
var massMeter
var damageGauge

# Called when the node enters the scene tree for the first time.
func _ready():
	#Start the game timer
	gameClock = get_node("Timer")
	gameClock.start(300)
	clockDisplay = get_node("VBoxContainer/TimerLabel")
	
	#define UI elements
	energyLevel = get_node("VBoxContainer/MeterContainer/EnergyLevel")
	massMeter = get_node("VBoxContainer/MeterContainer/MassMeter")
	damageGauge = get_node("VBoxContainer/MeterContainer/DamageGauge")


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	#update clock display
	var minutes = int(gameClock.get_time_left()/60)
	var seconds = int(gameClock.get_time_left()) % 60
	#pad zero if single digit seconds remain
	if seconds < 10:
		seconds = "0" + str(seconds)
	clockDisplay.set_text(str(minutes) + ":" + str(seconds))

#sets UI text
func updateUI(energy, mass, damage):
	energyLevel.set_text(str(energy))
	massMeter.set_text(str(mass))
	damageGauge.set_text(str(damage))
	
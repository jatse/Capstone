extends Button

var toggledState = false
var originalText = ""

#Preserve original button text
func _ready():
	originalText = self.text

#Prime for key input
# warning-ignore:unused_argument
func _on_ChangeKey_toggled(button_pressed):
	if !toggledState: #Only if not already primed
		self.text = "[Press any key]"
		toggledState = true
	
func _input(event):
	#execute only if primed
	if toggledState:
		#if Mouse button pressed, do not register, and untoggle
		if event is InputEventMouseButton:
			toggledState = false
			self.text = originalText
			self.pressed = false
			
		#if keyboard event, register, and untoggle
		if event is InputEventKey:
			var action = self.get_parent().name
			self.get_parent().get_parent().map_key_to_action(event.scancode, action)
			self.text = originalText
			self.pressed = false
		
		#if event is InputJoypadButton:
			
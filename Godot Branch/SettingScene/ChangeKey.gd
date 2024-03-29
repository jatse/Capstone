extends Button

var toggledState = false
var originalText = ""
var sceneRoot

#Preserve original button text
func _ready():
	sceneRoot = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
	originalText = self.text

#Prime for key input
# warning-ignore:unused_argument
func _on_ChangeKey_toggled(button_pressed):
	if !toggledState: #Only if not already primed
		self.text = "[Press any key]"
		toggledState = true
		sceneRoot.playAudio()
	
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
			#get name of action from parent container
			var action = self.get_parent().name
			#use name to map input to action
			sceneRoot.map_key_to_action(event.get_class(), event.scancode, action)
			#deselect button toggle && restore
			toggledState = false
			self.text = originalText
			#prevent retoggling from key assignment
			self.pressed = false
			sceneRoot.playAudio()
			
		#if joypad button event, register, and untoggle
		if event is InputEventJoypadButton:
			var action = self.get_parent().name
			sceneRoot.map_key_to_action(event.get_class(), event.button_index, action)
			toggledState = false
			self.text = originalText
			self.pressed = false
			sceneRoot.playAudio()
			
		#if joypad button event, register, and untoggle
		if event is InputEventJoypadMotion:
			var action = self.get_parent().name
			sceneRoot.map_key_to_action(event.get_class(), event.axis, action, event.axis_value)
			toggledState = false
			self.text = originalText
			self.pressed = false
			sceneRoot.playAudio()
		
		#Prevent keypress from propagating
		#If enter/accept used for key, it won't prime again.
		get_tree().set_input_as_handled()

func _on_ChangeKey_focus_entered():
	sceneRoot.playAudio()

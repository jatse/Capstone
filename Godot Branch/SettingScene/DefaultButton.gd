extends Button

func _on_DefaultButton_pressed():
	get_parent().get_node("ControlsMenu").set_keys_to_default()

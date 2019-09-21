extends Button

onready var soundPlayer = get_node("../../../../AudioStreamPlayer")

func _on_DefaultButton_pressed():
	get_parent().get_parent().get_parent().get_parent().set_keys_to_default()
	soundPlayer.play()


func _on_DefaultButton_focus_entered():
	soundPlayer.play()

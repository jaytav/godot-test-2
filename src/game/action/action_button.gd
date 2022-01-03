extends Button

var action: Action


func _on_ActionButton_pressed():
	ActionController.draw_action(action)

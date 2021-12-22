extends Node

signal transitioned(from_state, to_state)

var _active_state: State


func _ready():
	_active_state = get_node("Idle")
	_active_state.enter()

	emit_signal("transitioned", null, _active_state)


func _process(delta):
	_active_state.process(delta)


func _physics_process(delta):
	_active_state.physics_process(delta)


func _unhandled_input(event):
	_active_state.unhandled_input(event)


func transition_to_state(state: String) -> void:
	var from_state: State = _active_state
	var to_state: State = get_node(state)

	_active_state.exit()
	_active_state = to_state
	_active_state.enter()

	emit_signal("transitioned", from_state, _active_state)


func _on_StateMachine_transitioned(from_state: State, to_state: State):
	if from_state:
		print("%s transitioned from %s to %s" % [owner.name, from_state.name, to_state.name])
	else:
		print("%s transitioned to %s" % [owner.name, to_state.name])

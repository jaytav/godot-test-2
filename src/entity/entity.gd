class_name Entity
extends Node2D

signal turn_started
signal turn_ended

onready var _state_machine = get_node("StateMachine")


func get_stat(stat: String):
    return get_node("Stats/%s" % stat)


func start_turn() -> void:
    _state_machine.transition_to_state("Active")
    emit_signal("turn_started")


func end_turn() -> void:
    _state_machine.transition_to_state("Idle")
    emit_signal("turn_ended")

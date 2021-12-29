class_name Entity
extends Node2D

signal turn_started(entity)
signal turn_ended(entity)

var stats: Dictionary

onready var _state_machine = get_node("StateMachine")


func _ready():
    for stat in get_node("Stats").get_children():
        stats[stat.name] = stat


func start_turn() -> void:
    _state_machine.transition_to_state("Move")
    emit_signal("turn_started", self)


func end_turn() -> void:
    _state_machine.transition_to_state("Idle")
    emit_signal("turn_ended", self)

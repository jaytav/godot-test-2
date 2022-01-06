class_name Entity
extends Node2D

signal turn_started(entity)
signal turn_ended(entity)
signal died(entity)

var stats: Dictionary


func _ready():
    for stat in get_node("Stats").get_children():
        stats[stat.name] = stat


func start_turn() -> void:
    emit_signal("turn_started", self)


func end_turn() -> void:
    emit_signal("turn_ended", self)


func _on_HealthPoints_updated(from_value: int, to_value: int):
    if to_value == 0:
        queue_free()
        emit_signal("died", self)

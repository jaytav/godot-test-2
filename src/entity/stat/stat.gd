class_name Stat
extends Node

signal updated(from_value, to_value)

export var initial_value: int

var value: int setget _set_value


func _ready():
	value = initial_value


func _set_value(to_value: int) -> void:
	var from_value: int = value
	value = to_value
	emit_signal("updated", from_value, value)

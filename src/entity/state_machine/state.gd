class_name State
extends Node

var state_machine


func _ready():
	state_machine = get_parent()


func enter() -> void:
	pass


func exit() -> void:
	pass


func process(_delta) -> void:
	pass


func physics_process(_delta) -> void:
	pass


func unhandled_input(_event) -> void:
	pass

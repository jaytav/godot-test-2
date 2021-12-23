class_name TurnQueue
extends Node

var entities: Array setget _set_entities

var _active_entity: Entity


func start_next_turn() -> void:
	if _active_entity != null:
		_active_entity.disconnect("turn_ended", self, "start_next_turn")
		entities.push_back(_active_entity)

	_active_entity = entities.pop_front()
	_active_entity.connect("turn_ended", self, "start_next_turn")
	_active_entity.start_turn()


func _set_entities(to_entities: Array) -> void:
	entities = to_entities
	entities.sort_custom(self, "_sort_entities")


func _sort_entities(a: Entity, b: Entity) -> bool:
	return a.get_stat("Initiative").value > b.get_stat("Initiative").value

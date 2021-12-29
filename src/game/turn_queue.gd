extends Node

var turn_queue_ui
var entities: Array setget _set_entities

var _active_entity: Entity


func start_next_turn() -> void:
    if _active_entity != null:
        _active_entity.disconnect("turn_ended", self, "_on_active_entity_turn_ended")
        entities.push_back(_active_entity)

    _active_entity = entities.pop_front()
    _active_entity.connect("turn_ended", self, "_on_active_entity_turn_ended")
    _active_entity.connect("turn_ended", turn_queue_ui, "_on_active_entity_turn_ended")
    _active_entity.start_turn()


func _set_entities(to_entities: Array) -> void:
    to_entities.sort_custom(self, "_sort_entities")

    entities = to_entities
    turn_queue_ui.entities = to_entities


func _sort_entities(a: Entity, b: Entity) -> bool:
    return a.get_stat("Initiative").value > b.get_stat("Initiative").value


func _on_active_entity_turn_ended(_entity: Entity):
    start_next_turn()

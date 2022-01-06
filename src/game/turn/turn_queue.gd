extends Node

var turn_queue_ui: Control
var entities: Array

var _active_entity: Entity


func _init():
    EntityController.connect("entities_updated", self, "_on_EntityController_entitites_updated")


func _on_EntityController_entitites_updated(_from_entities: Array, to_entities: Array) -> void:
    entities = []

    for entity in to_entities:
        entities.append(entity)


func start_next_turn() -> void:
    if _active_entity != null:
        _active_entity.disconnect("turn_ended", self, "_on_active_entity_turn_ended")
        entities.push_back(_active_entity)

    _active_entity = entities.pop_front()
    _active_entity.connect("turn_ended", self, "_on_active_entity_turn_ended")
    _active_entity.connect("turn_ended", turn_queue_ui, "_on_active_entity_turn_ended")
    _active_entity.start_turn()


func _on_active_entity_turn_ended(_entity: Entity):
    start_next_turn()

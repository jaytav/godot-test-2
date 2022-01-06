extends Node

signal entities_updated(from_entities, to_entities)

var entities: Array setget _set_entities
var entity_cells: Dictionary


func _sort_entities(a: Entity, b: Entity) -> bool:
    return a.stats.Initiative.value > b.stats.Initiative.value


func _set_entities(to_entities) -> void:
    var from_entities: Array = entities
    var only_player_entities: bool = true

    entities = to_entities
    entities.sort_custom(self, "_sort_entities")
    entity_cells = {}

    for entity in entities:
        if only_player_entities and !entity.is_in_group("PlayerControlled"):
            only_player_entities = false

        entity.connect("died", self, "_on_entity_died")
        entity_cells[ActionController.action_tile_map.world_to_map(entity.position)] = entity

    if only_player_entities:
        print("player wins")
        get_tree().quit()

    emit_signal("entities_updated", from_entities, entities)


func _on_entity_died(dead_entity: Entity) -> void:
    dead_entity.disconnect("died", self, "_on_entity_died")
    var to_entities: Array = []

    for entity in entities:
        if dead_entity == entity:
            continue

        to_entities.append(entity)

    _set_entities(to_entities)

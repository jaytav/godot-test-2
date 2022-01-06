class_name TurnQueueUI
extends Control

onready var item_list: ItemList = get_node("ItemList")


func _init():
    EntityController.connect("entities_updated", self, "_on_EntityController_entitites_updated")


func _on_EntityController_entitites_updated(_from_entities: Array, _to_entities: Array) -> void:
    item_list.clear()

    for i in range(len(EntityController.entities)):
        var sprite: Sprite = EntityController.entities[i].get_node("Sprite")
        item_list.add_icon_item(sprite.texture)
        item_list.set_item_icon_modulate(i, sprite.modulate)


func _on_active_entity_turn_ended(_entity: Entity):
    item_list.move_item(0, len(EntityController.entities))

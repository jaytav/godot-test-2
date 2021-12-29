class_name TurnQueueUI
extends Control

var entities: Array setget _set_entities

onready var item_list: ItemList = get_node("ItemList")


func _set_entities(to_entities: Array):
    entities = to_entities

    for i in range(len(entities)):
        var sprite: Sprite = entities[i].get_node("Sprite")
        item_list.add_item(entities[i].name, sprite.texture)
        item_list.set_item_icon_modulate(i, sprite.modulate)


func _on_active_entity_turn_ended(_entity: Entity):
    item_list.move_item(0, len(entities))

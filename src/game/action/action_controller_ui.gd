extends Control

const ActionButton = preload("res://src/game/action/ActionButton.tscn")

var entity: Entity setget _set_entity

onready var _grid_container: GridContainer = get_node("GridContainer")


func _set_entity(_entity: Entity):
    entity = _entity

    for child in _grid_container.get_children():
        _grid_container.remove_child(child)

    for action in _entity.get_node("Actions").get_children():
        var action_button = ActionButton.instance()
        action_button.action = action
        action_button.text = action.name
        _grid_container.add_child(action_button)

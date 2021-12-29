extends Node

onready var _status_effects: Array = get_children()


func _on_Entity_turn_ended(_entity: Entity):
    for status_effect in _status_effects:
        status_effect.do_effect()

extends Entity

onready var active_action: Action = get_node("Actions/Move")


func _init():
    add_to_group("PlayerControlled")


func _on_Player_turn_started(_entity: Entity):
    ActionController.draw_action(active_action)

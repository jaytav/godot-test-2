extends Node


func _ready():
    ActionController.action_tile_map = get_node("World/Action")
    ActionController.action_controller_ui = get_node("GUI/ActionControllerUI")
    ActionController.floor_tile_map = get_node("World/Floor")

    EntityController.entities = get_node("World/Entities").get_children()

    TurnQueue.turn_queue_ui = get_node("GUI/TurnQueueUI")
    TurnQueue.start_next_turn()

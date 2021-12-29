extends Node

onready var entities: Array = get_node("World/Entities").get_children()


func _ready():
    ActionController.floor_tile_map = get_node("World/Floor")
    ActionController.action_tile_map = get_node("World/Action")
    ActionController.entities = entities

    TurnQueue.turn_queue_ui = get_node("GUI/TurnQueueUI")
    TurnQueue.entities = entities
    TurnQueue.start_next_turn()

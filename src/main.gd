extends Node

onready var entities: Array = get_node("World/Entities").get_children()


func _ready():
    TurnQueue.turn_queue_ui = get_node("GUI/TurnQueueUI")
    TurnQueue.entities = entities
    TurnQueue.start_next_turn()

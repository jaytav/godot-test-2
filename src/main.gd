extends Node

onready var entities: Array = get_node("World/Entities").get_children()


func _ready():
    TurnQueue.entities = entities
    TurnQueue.start_next_turn()

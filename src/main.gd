extends Node

var _turn_queue: TurnQueue = TurnQueue.new()

onready var entities: Array = get_node("World/Entities").get_children()


func _ready():
    _turn_queue.entities = entities
    _turn_queue.start_next_turn()

extends Path2D

signal entity_moved(entity)

var entity: Entity

onready var _path_follow: PathFollow2D = get_node("PathFollow2D")


func _init():
    curve.clear_points()


func _ready():
    get_node("PathFollow2D/RemoteTransform2D").remote_path = entity.get_path()


func _process(delta):
    if _path_follow.unit_offset == 1:
        emit_signal("entity_moved", entity)
        queue_free()

    _path_follow.offset += delta * 50

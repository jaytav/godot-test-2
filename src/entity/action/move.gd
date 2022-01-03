extends Action

const EntityMover = preload("res://src/game/mover/EntityMover.tscn")

func _ready():
    yield(owner, "ready")
    max_range = owner.stats.ActionPoints.value


func do_action(request: Dictionary):
    var entity_mover = EntityMover.instance()
    entity_mover.connect("entity_moved", self, "_on_EntityMover_entity_moved")
    entity_mover.entity = request.entity

    for point_path_position in request.point_path_positions:
        var point_path_world_position: Vector2 = ActionController.action_tile_map.map_to_world(point_path_position)
        point_path_world_position.y += ActionController.action_tile_map.cell_size.y / 2
        entity_mover.curve.add_point(point_path_world_position)

    request.entity.stats.ActionPoints.value -= len(request.point_path_positions) - 1
    owner.owner.get_node("World").add_child(entity_mover)


func _on_ActionPoints_updated(_from_value: int, to_value: int):
    max_range = to_value


func _on_EntityMover_entity_moved(entity: Entity):
    ActionController.refresh_astar()

    if entity.is_in_group("PlayerControlled"):
        entity.active_action = entity.get_node("Actions/Move")
        ActionController.draw_action(entity.active_action)

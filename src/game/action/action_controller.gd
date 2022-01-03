extends Node


var action_controller_ui: Control
var entities: Array setget _set_entities
var action_tile_map: TileMap
var floor_tile_map: TileMap


var _active_entity: Entity
var _astar: AStar2D = AStar2D.new()
var _entity_cells: Array = []
var _action_cell: Vector2


func do_action(action: Action, position: Vector2) -> void:
    var action_cell: Vector2 = action_tile_map.world_to_map(position)
    var used_cells: Array = action_tile_map.get_used_cells()

    if !used_cells.has(action_cell):
        return

    var request: Dictionary = {
        "entity": action.owner,
        "entity_position": action.owner.position,
        "entity_cell": action_tile_map.world_to_map(action.owner.position),
        "action_position": position,
        "action_cell": action_cell,
    }

    if action.use_point_path:
        request.entity_point = _get_vector_point_index(request.entity_cell)
        request.action_point = _get_vector_point_index(request.action_cell)
        request.point_path_positions = _astar.get_point_path(request.entity_point, request.action_point)

    action.do_action(request)


func draw_action(action: Action) -> void:
    action_tile_map.clear()
    action_tile_map.modulate = action.tile_map_modulate

    var entity_cell: Vector2 = action_tile_map.world_to_map(action.owner.position)
    var entity_point = _get_vector_point_index(entity_cell)

    if action.use_point_path:
        for point in _astar.get_points():
            var point_path_positions: PoolVector2Array = _astar.get_point_path(entity_point, point)

            # remove entity point position
            point_path_positions.remove(0)

            if len(point_path_positions) > action.max_range:
                continue

            for point_path_position in point_path_positions:
                action_tile_map.set_cellv(point_path_position, 0)
    else:
        for point in _astar.get_points():
            var cell: Vector2 = _astar.get_point_position(point)
            var difference: int = int(abs(entity_cell.x - cell.x) + abs(entity_cell.y - cell.y))

            if difference >= action.min_range && difference <= action.max_range:
                action_tile_map.set_cellv(cell, 0)


func draw_action_behaviour(action: Action, position: Vector2) -> void:
    var action_cell: Vector2 = action_tile_map.world_to_map(position)
    var entity_cell: Vector2 = action_tile_map.world_to_map(action.owner.position)

    if action_cell == _action_cell:
        return

    var used_cells: Array = action_tile_map.get_used_cells()

    for used_cell in used_cells:
        action_tile_map.set_cellv(used_cell, 0)

    if !used_cells.has(action_cell):
        _action_cell = Vector2.ZERO
        return

    var entity_point: int = _get_vector_point_index(entity_cell)
    var action_point: int = _get_vector_point_index(action_cell)
    var point_path_positions: PoolVector2Array = _astar.get_point_path(entity_point, action_point)

    # remove entity point position
    point_path_positions.remove(0)

    for point_path_position in point_path_positions:
        action_tile_map.set_cellv(point_path_position, 1)

    _action_cell = action_cell


func refresh_astar():
    _entity_cells = []

    for entity in entities:
        _entity_cells.append(action_tile_map.world_to_map(entity.position))

    for cell in floor_tile_map.get_used_cells():
        _astar.add_point(_get_vector_point_index(cell), cell)

    for point in _astar.get_points():
        var cell: Vector2 = _astar.get_point_position(point)

        var relative_cells: PoolVector2Array = [
            Vector2(cell.x + 1, cell.y),
            Vector2(cell.x - 1, cell.y),
            Vector2(cell.x, cell.y + 1),
            Vector2(cell.x, cell.y - 1),
        ]

        for relative_cell in relative_cells:
            var relative_cell_point: int = _get_vector_point_index(relative_cell)

            if !_astar.has_point(relative_cell_point):
                continue

            if _entity_cells.has(relative_cell):
                continue

            _astar.connect_points(point, relative_cell_point, false)


func _get_vector_point_index(position: Vector2) -> int:
    var vector_point_index: int = int("%s%s" % [position.y, position.x])

    if vector_point_index < 0:
        vector_point_index += 999999

    return vector_point_index


func _set_entities(to_entities: Array):
    entities = to_entities
    refresh_astar()

    for entity in entities:
        if entity.is_in_group("PlayerControlled"):
            entity.connect("turn_started", self, "_on_PlayerControlled_Entity_turn_started")
            entity.connect("turn_ended", self, "_on_PlayerControlled_Entity_turn_ended")


func _on_PlayerControlled_Entity_turn_started(entity: Entity) -> void:
    action_controller_ui.entity = entity


func _on_PlayerControlled_Entity_turn_ended(_entity: Entity) -> void:
    action_tile_map.clear()

extends Node

const EntityMover = preload("res://src/game/mover/EntityMover.tscn")

export var _action_movement_modulate: Color = Color("#deffcf")

var entities: Array setget _set_entities
var action_tile_map: TileMap
var floor_tile_map: TileMap

var _astar: AStar2D = AStar2D.new()
var _entity_cells: Array = []


func request_action(request: Dictionary) -> void:
    var mouse_position: Vector2 = request.mouse_position
    var entity: Entity = request.entity
    var type: String = request.type

    if type == "move":
        var entity_position: Vector2 = action_tile_map.world_to_map(entity.position)
        var action_position: Vector2 = action_tile_map.world_to_map(mouse_position)
        var entity_point: int = _get_vector_point_index(entity_position)
        var action_point: int = _get_vector_point_index(action_position)
        var point_path_positions: PoolVector2Array = _astar.get_point_path(entity_point, action_point)
        var move_cost: int = len(point_path_positions) - 1

        if move_cost <= 0:
            print("%s cannot move here" % entity.name)
            return

        if move_cost > entity.stats.ActionPoints.value:
            print("%s too far to move" % entity.name)
            return

        entity.stats.ActionPoints.value -= move_cost

        var entity_mover = EntityMover.instance()
        entity_mover.connect("entity_moved", self, "_on_EntityMover_entity_moved")
        entity_mover.entity = entity

        for point_path_position in point_path_positions:
            var point_path_world_position: Vector2 = action_tile_map.map_to_world(point_path_position)
            point_path_world_position.y += action_tile_map.cell_size.y / 2
            entity_mover.curve.add_point(point_path_world_position)

        get_parent().get_node("Main/World").add_child(entity_mover)


func draw_movement(entity: Entity):
    action_tile_map.clear()
    action_tile_map.modulate = _action_movement_modulate

    var action_points: int = entity.stats.ActionPoints.value
    var entity_position = action_tile_map.world_to_map(entity.position)
    var entity_point = _get_vector_point_index(entity_position)

    for point in _astar.get_points():
        var point_path_positions: PoolVector2Array = _astar.get_point_path(entity_point, point)

        if len(point_path_positions) == 0:
            continue

        # remove entity point position
        point_path_positions.remove(0)

        if len(point_path_positions) > action_points:
            continue

        for point_path_position in point_path_positions:
            if point_path_position == entity_position:
                continue

            action_tile_map.set_cellv(point_path_position, 0)


func _refresh_astar():
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
    _refresh_astar()

    for entity in entities:
        if entity.is_in_group("PlayerControlled"):
            entity.connect("turn_started", self, "_on_PlayerControlled_Entity_turn_started")
            entity.connect("turn_ended", self, "_on_PlayerControlled_Entity_turn_ended")


func _on_PlayerControlled_Entity_turn_started(entity: Entity) -> void:
    draw_movement(entity)


func _on_PlayerControlled_Entity_turn_ended(_entity: Entity) -> void:
    action_tile_map.clear()


func _on_EntityMover_entity_moved(entity: Entity):
    _refresh_astar()
    draw_movement(entity)

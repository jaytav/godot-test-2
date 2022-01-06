extends Action

export var damage: int
export var action_point_cost: int


func do_action(request: Dictionary):
    if EntityController.entity_cells.has(request.action_cell):
        var attacked_entity: Entity = EntityController.entity_cells[request.action_cell]
        attacked_entity.stats.HealthPoints.value -= damage

    request.entity.stats.ActionPoints.value -= action_point_cost

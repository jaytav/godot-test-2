extends StatusEffect

export var stat_path: NodePath

onready var _stat: Stat = get_node(stat_path)


func do_effect():
    _stat.value = _stat.max_value

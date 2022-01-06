extends TextureProgress

onready var health_points: Stat = owner.get_node("Stats/HealthPoints")


func _ready():
    min_value = health_points.min_value
    max_value = health_points.max_value
    value = health_points.value

    if owner.is_in_group("PlayerControlled"):
        tint_progress = Color("a1d7b0")
        tint_under = Color("d3ebd4")

func _on_HealthPoints_updated(_from_value: int, to_value: int):
    value = to_value

extends State


func unhandled_input(event):
    if event is InputEventMouseMotion:
        ActionController.draw_action_behaviour(owner.active_action, owner.get_global_mouse_position())
    if event.is_action_pressed("left_click"):
        ActionController.do_action(owner.active_action, owner.get_global_mouse_position())
    elif event.is_action_pressed("ui_select"): # press space to end turn
        owner.end_turn()

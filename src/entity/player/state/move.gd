extends State

func unhandled_input(event):
    if event.is_action_pressed("left_click"):
        var request: Dictionary = {
            "mouse_position": owner.get_global_mouse_position(),
            "type": "move",
            "entity": owner,
        }

        ActionController.request_action(request)
    # press space to end turn
    elif event.is_action_pressed("ui_select"):
        owner.end_turn()

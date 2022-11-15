extends MarginContainer

var won = "Not Set" # super hacky, that var should become a bool later

onready var buttons = $"Panel/MarginContainer/VBoxContainer"

func _ready():
    # won flag needs to be set before entering the tree
    if won == "Not Set":
        breakpoint
    elif won:
        pass
    else:
        # TODO: what if level is already unlocked?
        # TODO: better to do a check if level is unlocked and then enable/disable button
        buttons.get_node("NextLevel").hide()


func _on_NextLevel_button_down():
	pass # Replace with function body.


func _on_Restart_button_down():
    pass # Replace with function body.


func _on_Options_button_down():
	pass # Replace with function body.


func _on_MainMenu_button_down():
	pass # Replace with function body.

    

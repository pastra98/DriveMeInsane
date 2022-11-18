extends MarginContainer

# create new signals here for every button signal that is received. maybe a bit ugly
signal restart

var setup_complete = false

onready var buttons: VBoxContainer

func _ready():
    # check if level_won or level_lost has been called
    if not setup_complete:
        print("Level must be setup before adding game over screen to tree")
        breakpoint
    pass


func setup(lvl_nr: int, stars: int, next_lvl_unlock: bool, points: int):
    setup_complete = true
    # hide next level button if not unlocked
    buttons = $"Panel/MarginContainer/VBoxContainer"
    if not next_lvl_unlock:
        buttons.get_node("NextLevel").hide()
    print("We got %s stars!!!" % stars)
    # TODO: show text info etc based on lvl_passed
    var success = "completed" if stars > 0 else "failed"
    buttons.get_node("Text").text = "Lvl %s!" % success
    buttons.get_node("Points").text = str(points)


func _on_NextLevel_button_down():
    pass # Replace with function body.


func _on_Options_button_down():
    pass # Replace with function body.


func _on_MainMenu_button_down():
    pass # Replace with function body.


func _on_Restart_button_down():
    emit_signal("restart")
    queue_free()


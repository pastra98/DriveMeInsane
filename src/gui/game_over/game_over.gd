extends MarginContainer

var level_nr: int

onready var buttons: VBoxContainer
onready var main = get_node("/root/Main")
onready var level = get_node("/root/Main/Level")

func _ready():
    # check if setup has been called
    if not level_nr:
        print("Level must be setup before adding game over screen to tree")
        breakpoint
    pass


func setup(lvl_nr: int, stars: int, next_lvl_unlock: bool, points: int):
    level_nr = lvl_nr
    # hide next level button if not unlocked
    buttons = $"Panel/MarginContainer/VBoxContainer"
    if not next_lvl_unlock:
        buttons.get_node("NextLevel").hide()
    # TODO: show text info etc based on lvl_passed
    var success = "completed" if stars > 0 else "failed"
    buttons.get_node("Text").text = "Lvl %s!" % success
    buttons.get_node("Points").text = str(points)


func _on_NextLevel_button_down():
    main.load_level(level_nr + 1)
    queue_free()


func _on_Options_button_down():
    pass # Replace with function body.


func _on_MainMenu_button_down():
    pass # Replace with function body.


func _on_Restart_button_down():
    level.restart_level()
    queue_free()


extends MarginContainer

var level_nr: int
var achieved_stars: int

onready var main = get_node("/root/Main")
onready var level = get_node("/root/Main/Level")

func _ready():
    # check if setup has been called
    if not level_nr:
        print("Level must be setup before adding game over screen to tree")
        breakpoint
    # show stars, TODO: if really bored, can use tween and transform to make scale effect
    for _s in achieved_stars:
        yield(get_tree().create_timer(0.5), "timeout")
        var star_tex = $"Panel/MarginContainer/VBoxContainer/Stars".get_child(_s)
        star_tex.texture = load("res://gui/game_over/star.png")
        $StarSound.play()


func setup(lvl_nr: int, stars: int, next_lvl_unlock: bool, points: int):
    achieved_stars = stars
    level_nr = lvl_nr
    # hide next level button if not unlocked
    var buttons = $"Panel/MarginContainer/VBoxContainer"
    if not next_lvl_unlock:
        buttons.get_node("NextLevel").hide()
    # TODO: show text info etc based on lvl_passed
    var success = "completed" if stars > 0 else "failed"
    buttons.get_node("Text").text = "Lvl %s!" % success
    buttons.get_node("Points").text = str(points)



func _on_NextLevel_button_down():
    main.load_level(level_nr + 1)
    queue_free()


func _on_MainMenu_button_down():
    GuiManager.show_main_menu()
    queue_free()


func _on_Restart_button_down():
    level.restart_level()
    queue_free()


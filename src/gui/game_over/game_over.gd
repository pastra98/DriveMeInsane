extends Control

var level_nr: int
var achieved_stars: int
var success: String

@onready var main = get_node("/root/Main")
@onready var level = get_node("/root/Main/Level")

func _ready():
    # check if setup has been called
    if not level_nr:
        print("Level must be setup before adding game over screen to tree")
        breakpoint
    for _s in achieved_stars:
        await get_tree().create_timer(0.5).timeout
        var star_tex = $"Panel/MarginContainer/VBoxContainer/Stars".get_child(_s)
        star_tex.texture = load("res://gui/game_over/star.png")
        $StarSound.play()
    # hide next level if this is last level
    if level_nr == main.n_lvls:
        $"Panel/MarginContainer/VBoxContainer/NextLevel".hide()
        if success == "completed": # normally this should be a boolean but I can't give a crap anymore
            await get_tree().create_timer(2).timeout
            $"EndGamePopup".popup_centered()


func setup(lvl_nr: int, stars: int, next_lvl_unlock: bool, points: int):
    achieved_stars = stars
    level_nr = lvl_nr
    # hide next level button if not unlocked
    var buttons = $"Panel/MarginContainer/VBoxContainer"
    if not next_lvl_unlock:
        buttons.get_node("NextLevel").hide()
    success = "completed" if stars > 0 else "failed"
    buttons.get_node("Text").text = "Lvl %s!" % success
    buttons.get_node("Points").text = str(points)



func _on_NextLevel_button_down():
    MusicPlayer.button_sound()
    main.load_level(level_nr + 1)
    queue_free()


func _on_MainMenu_button_down():
    MusicPlayer.button_sound()
    GuiManager.show_main_menu()
    queue_free()


func _on_Restart_button_down():
    MusicPlayer.button_sound()
    level.restart_level()
    queue_free()


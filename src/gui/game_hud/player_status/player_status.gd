extends MarginContainer

# TODO: hindsight 2020, this stuff should all happen in a script attached to the game hud scene

@onready var bar = $"HBoxContainer/Health"
@onready var score = $"HBoxContainer/Score"
@onready var min_pts = $"../..".main.curr_lvl.points_1_star

var cur_score = 0
var col = ""


func update_health(new_health):
    bar.value = new_health
    

func update_score(new_score):
    cur_score = new_score
    col = "[color=yellow]" if new_score >= min_pts else ""
    score.text = col + "[wave amp=50 freq=10]" + str(cur_score)
    $Timer.start(1)


func _on_Timer_timeout():
    # TODO: this whole thing can be done in a better way
    score.text = col + str(cur_score)
    $Timer.stop()
    # check with main if the last tutorial thing should still be shown
    if not get_node("/root/Main").is_tutorial_completed:
        $"../FullRageTutorial".popup_centered()
        get_tree().paused = true
        await $"../FullRageTutorial".popup_hide
        get_tree().paused = false
        get_node("/root/Main").is_tutorial_completed = true

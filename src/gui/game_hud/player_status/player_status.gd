extends MarginContainer


onready var bar = $"HBoxContainer/Health"
onready var score = $"HBoxContainer/Score"
onready var min_pts = $"../..".main.curr_lvl.points_1_star

var cur_score = 0
var col = ""


func update_health(new_health):
    bar.value = new_health
    


func update_score(new_score):
    cur_score = new_score
    col = "[color=yellow]" if new_score >= min_pts else ""
    score.bbcode_text = col + "[wave amp=50 freq=10]" + str(cur_score)
    $Timer.start(1)


func _on_Timer_timeout():
    # TODO: this whole thing can be done in a better way
    score.bbcode_text = col + str(cur_score)
    $Timer.stop()

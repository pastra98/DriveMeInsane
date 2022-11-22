extends MarginContainer


onready var bar = $HBoxContainer/Health
onready var score = $HBoxContainer/Score


func update_health(new_health):
    bar.value = new_health


func update_score(new_score):
    # TODO: later show how many pts missing for pass level /next star 
    score.text = str(new_score)

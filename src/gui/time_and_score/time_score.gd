extends MarginContainer

onready var time_label = $"HBoxContainer/TimeVBox/Time"
onready var score_label = $"HBoxContainer/ScoreVBox/Score"
onready var score_requirements = $"HBoxContainer/ScoreVBox/ScoreText"

onready var level = $"/root/Main/Level"

func _ready():
    # time_label.text = str(level.player.health)
    pass


func update_score(score):
    score_label.text = str(level.player.health)
    # TODO: get point levels going - probably best to also get that information from level


# func update_score

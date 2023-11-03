extends Node

const TIME_TO_TRAVERSE = 120

func _ready():
    var camera_tween = get_tree().create_tween()
    camera_tween.set_ease(Tween.EASE_IN_OUT)
    camera_tween.set_trans(Tween.TRANS_LINEAR)
    camera_tween.set_loops() # run infinite
    camera_tween.tween_property($Path2D/PathFollow2D, "progress_ratio", 1, TIME_TO_TRAVERSE)

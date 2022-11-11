extends Node2D

const TIME_TO_TRAVERSE = 60

func _ready():
    run_tween()


func run_tween():
    $Path2D/PathFollow2D/Camera2D/Tween.interpolate_property(
        $Path2D/PathFollow2D, "unit_offset",
        0, 1, TIME_TO_TRAVERSE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
    )
    $Path2D/PathFollow2D/Camera2D/Tween.start()
    yield($Path2D/PathFollow2D/Camera2D/Tween, "tween_all_completed")
    run_tween()

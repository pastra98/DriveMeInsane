class_name TooSlowSensibility
extends Node2D

signal change_insanity(amt, reason, is_broadcast)
onready var player = $"/root/Main/Level".player

var too_slow: int
var insanity_effect: float

var t = 0

func _init(speed_low_tol: int, insanity_eff: float):
    too_slow = speed_low_tol
    insanity_effect = insanity_eff
    name = "TooSlow"

func _physics_process(delta):
    t += delta
    if t > 0.2:
        var vel = player.get_current_kph()
        # prevent exploitation by just standing still
        if vel > 1 and vel < too_slow:
            emit_signal("change_insanity", insanity_effect, "Too Slow!!", false)
        t = 0

func get_txt_description() -> String:
    return "%s:\n+%s insanity when going under %s kph" % [name, insanity_effect, too_slow]

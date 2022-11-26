class_name TooFastSensibility
extends Node2D

signal change_insanity(amt, reason, is_broadcast)
onready var player = $"/root/Main/Level".player

var too_fast: int
var insanity_effect: float

var t = 0

func _init(speed_tol: int, insanity_eff: float):
    too_fast = speed_tol
    insanity_effect = insanity_eff
    name = "TooFast"

func _physics_process(delta):
    t += delta
    if t > 0.2 and player.get_current_kph() > too_fast:
        emit_signal("change_insanity", insanity_effect, "Too fast!!", false)
        t = 0

func get_txt_description() -> String:
    return "%s:\n+%s insanity when going over %s kph" % [name, insanity_effect, too_fast]

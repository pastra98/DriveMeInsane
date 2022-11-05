class_name TooFastSensibility
extends Node2D

signal inc_insanity(amt)

var too_fast: int
var insanity_effect: int

func _init(speed_tol: int, insanity_eff: int):
    too_fast = speed_tol
    insanity_effect = insanity_eff
    name = "TooFast"

func _physics_process(delta):
    if Player.get_current_kph() > too_fast:
        emit_signal("inc_insanity", insanity_effect)

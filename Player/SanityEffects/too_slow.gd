class_name TooSlowSensibility
extends Node2D

signal inc_insanity(amt)

var too_slow: int
var insanity_effect: int

func _init(speed_low_tol: int, insanity_eff: int):
    too_slow = speed_low_tol
    insanity_effect = insanity_eff
    name = "TooSlow"

func _physics_process(delta):
    if Player.get_current_kph() < too_slow:
        emit_signal("inc_insanity", insanity_effect)
        # this needs to not trigger when car is standing still at the start
class_name TooFastSensibility
extends Node2D

signal inc_insanity(amt, reason)
onready var player = $"/root/Main/Level".player

var too_fast: int
var insanity_effect: int

func _init(speed_tol: int, insanity_eff: int):
    too_fast = speed_tol
    insanity_effect = insanity_eff
    name = "TooFast"

func _physics_process(delta):
    if player.get_current_kph() > too_fast:
        emit_signal("inc_insanity", insanity_effect, "Too fast!!")

func get_txt_description() -> String:
    return "%s: +%s insanity when going over %s kph" % [name, insanity_effect, too_fast]
class_name DriftHater
extends Node2D

signal change_insanity(amt, reason, is_broadcast)

onready var car = $"../../.."
var t = 0

var insanity_effect: int

func _init(insanity_eff: int):
    # passenger = get_parent()
    insanity_effect = insanity_eff
    name = "DriftHater"

func _physics_process(delta):
    t += delta
    if t > 0.2:
        # check if drifting and prevent cheating by just going forward and hitting the brakes
        if car._drift_factor == car.WHEEL_GRIP_SLIPPERY and car.get_right_velocity().length() > 20:
            emit_signal("change_insanity", insanity_effect, "I hate screetching!!", false)
        t = 0

func get_txt_description() -> String:
    return "%s:\n+%s insanity while drifting (use SPACE for handbrake)." % [name, insanity_effect]
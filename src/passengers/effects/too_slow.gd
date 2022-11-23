class_name TooSlowSensibility
extends Node2D

signal change_insanity(amt, reason, is_broadcast)
onready var player = $"/root/Main/Level".player

var too_slow: int

var insanity_effect: int
var cooldown: int
var is_on_cooldown = false

func _init(speed_low_tol: int, insanity_eff: int, cooldown_time: int):
    too_slow = speed_low_tol
    insanity_effect = insanity_eff
    cooldown = cooldown_time
    name = "TooSlow"

func _physics_process(delta):
    var vel = player.get_current_kph()
    # prevent exploitation by just standing still
    if vel > 1 and vel < too_slow and not is_on_cooldown:
        emit_signal("change_insanity", insanity_effect, "Too Slow!!", false)
        get_node(name + "Timer").start(cooldown)
        is_on_cooldown = true


func get_txt_description() -> String:
    return "%s:\n+%s insanity when going under %s kph" % [name, insanity_effect, too_slow]


func cooldown_over():
    is_on_cooldown = false

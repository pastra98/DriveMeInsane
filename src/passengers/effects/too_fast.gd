class_name TooFastSensibility
extends Node2D

signal inc_insanity(amt, reason)
onready var player = $"/root/Main/Level".player

var too_fast: int

var insanity_effect: int
var cooldown: int
var is_on_cooldown = false

func _init(speed_tol: int, insanity_eff: int, cooldown_time: int):
    too_fast = speed_tol
    insanity_effect = insanity_eff
    cooldown = cooldown_time
    name = "TooFast"

func _physics_process(delta):
    print("I'm active!!!")
    if player.get_current_kph() > too_fast and not is_on_cooldown:
        emit_signal("inc_insanity", insanity_effect, "Too fast!!")
        get_node(name + "Timer").start(cooldown)
        is_on_cooldown = true

func get_txt_description() -> String:
    return "%s: +%s insanity when going over %s kph" % [name, insanity_effect, too_fast]


func cooldown_over():
    is_on_cooldown = false
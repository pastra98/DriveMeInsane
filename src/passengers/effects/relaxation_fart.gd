class_name RelaxationFart
extends Node2D

signal inc_everyones_insanity(amt, reason)
onready var passenger = get_parent()


var insanity_effect: int
var cooldown: int
var is_on_cooldown = false

func _init(insanity_eff: int, cooldown_time: int):
    # passenger = get_parent()
    insanity_effect = insanity_eff
    cooldown = cooldown_time
    name = "RelaxationFart"

func _physics_process(delta):
    if passenger.insanity == 0 and not is_on_cooldown:
        emit_signal("inc_everyones_insanity", insanity_effect, "Fart!")
        get_node(name + "Timer").start(cooldown)
        is_on_cooldown = true

func get_txt_description() -> String:
    return "%s: +%s insanity when passenger farts. Farts every %s seconds while insanity is 0" % [name, insanity_effect, cooldown]


func cooldown_over():
    is_on_cooldown = false

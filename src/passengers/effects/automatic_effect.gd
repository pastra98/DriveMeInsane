class_name AutomaticEffect
extends Node2D

signal change_insanity(amt, reason, is_broadcast)
onready var player = $"/root/Main/Level".player
onready var car = $"../../.."

var insanity_effect: float
var message: String
var is_broadcasting: bool
var cooldown: int

var is_on_cooldown = false

func _init(reason: String, is_broadcast: bool, insanity_eff: float, cooldown_time: int):
    message = reason
    is_broadcasting = is_broadcast
    insanity_effect = insanity_eff
    cooldown = cooldown_time
    name = "AutomaticEffect"

func _physics_process(delta):
    if not is_on_cooldown and car.acceleration != 0: # checks if car is enabled
        emit_signal("change_insanity", insanity_effect, message, is_broadcasting)
        # even when it is a broadcast, effect always applies to passenger aswell
        if is_broadcasting:
            emit_signal("change_insanity", insanity_effect, message, false)
        get_node(name + "Timer").start(cooldown)
        is_on_cooldown = true


func get_txt_description() -> String:
    var s = "+" if insanity_effect > 0 else ""
    var bc = ". Also changes everyone else's insanity" if is_broadcasting else ""
    return "%s:\n%s%s insanity every %s seconds" % [name, s, insanity_effect, bc]


func cooldown_over():
    is_on_cooldown = false

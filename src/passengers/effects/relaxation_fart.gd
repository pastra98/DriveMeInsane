class_name RelaxationFart
extends Node2D

signal change_insanity(amt, reason, is_broadcast)
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
        # start timer until next fart - must happen before yield, otherwise this get called multiple times
        get_node(name + "Timer").start(cooldown)
        is_on_cooldown = true
        # play fart and wait 1 sec b4 emitting broadcast
        get_node("../SoundPlayer").stream = load("res://audio/sounds/fart.wav")
        get_node("../SoundPlayer").play()
        yield(get_tree().create_timer(1), "timeout")
        # emit broadcast
        emit_signal("change_insanity", insanity_effect, "Fart!", true)

func get_txt_description() -> String:
    return "%s: +%s insanity when passenger farts. Farts every %s seconds while insanity is 0" % [name, insanity_effect, cooldown]


func cooldown_over():
    is_on_cooldown = false
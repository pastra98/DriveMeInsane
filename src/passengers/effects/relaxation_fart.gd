class_name RelaxationFart
extends Node2D

signal change_insanity(amt, reason, is_broadcast)

var rng = RandomNumberGenerator.new()

@onready var passenger = get_parent()
@onready var car = $"../../.."


var insanity_effect: float
var cooldown: int
var is_on_cooldown = false

func _init(insanity_eff: float, cooldown_time: int):
    # passenger = get_parent()
    insanity_effect = insanity_eff
    cooldown = cooldown_time
    name = "RelaxationFart"

func _physics_process(delta):
    if passenger.insanity == 0 and not is_on_cooldown and car.acceleration != 0:
        # start timer until next fart - must happen before yield, otherwise this get called multiple times
        get_node(name + "Timer").start(cooldown)
        is_on_cooldown = true
        # play fart and wait 1 sec b4 emitting broadcast
        get_node("../SoundPlayer").stream = load("res://audio/sounds/FX_DryFart%s.wav" % rng.randi_range(1,2))
        # TODO: make this better, maybe a play sound method in the passenger
        var prev_vol = get_node("../SoundPlayer").volume_db
        get_node("../SoundPlayer").volume_db = -20
        get_node("../SoundPlayer").play()
        await get_tree().create_timer(1).timeout
        get_node("../SoundPlayer").volume_db = prev_vol
        # emit broadcast
        emit_signal("change_insanity", insanity_effect, "Fart!", true)

func get_txt_description() -> String:
    return "%s:\n+%s insanity when passenger farts. Farts every %s seconds while insanity is 0" % [name, insanity_effect, cooldown]


func cooldown_over():
    is_on_cooldown = false

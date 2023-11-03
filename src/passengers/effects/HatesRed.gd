class_name HatesRed
extends Node2D

signal change_insanity(amt, reason, is_broadcast)

var insanity_effect: float
var cooldown: int
var is_on_cooldown = false

func _ready():
    var car = $"../../.."
    car.connect("crashed_stopsign", Callable(self, "crash_stopsign")) # TODO: this is all so shitty

func _init(insanity_eff: float, cooldown: int):
    insanity_effect = insanity_eff
    name = "HatesRed"

func crash_stopsign(): # gets triggered by signal, connected in passenger.gd
    if not is_on_cooldown:
        emit_signal("change_insanity", insanity_effect, "Red!!!", false)
        get_node(name + "Timer").start(cooldown)
        is_on_cooldown = true


func cooldown_over():
    is_on_cooldown = false


func get_txt_description() -> String:
    return "%s:\n+%s insanity whenever you crash into a stopsign" % [name, insanity_effect]
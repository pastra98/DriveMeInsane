extends Node2D

var insanity: int = 0
var sensibilities: Array = []

func _ready():
    add_too_close(20, 10, 2)
    pass

func insanity_change(change_by):
    insanity += change_by
    print(insanity)

func add_too_close(speed_tol: int, effect: int, size_mult: float):
    var too_close = load("res://Player/SanityEffects/too_close.gd").new(speed_tol, effect, size_mult)
    too_close.connect("inc_insanity", self, "insanity_change")
    add_child(too_close)

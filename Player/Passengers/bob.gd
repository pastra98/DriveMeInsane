extends Node2D

var insanity: int = 0
var sensibilities: Array = []

func _ready():
    add_too_close(20, 10)
    pass

func insanity_change(change_by):
    insanity += change_by
    print(insanity)

func add_too_close(speed_tol: int, effect: int):
    var too_close = load("res://Player/SanityEffects/TooClose/TooClose.tscn").instance()
    too_close.speed_tolerance = speed_tol
    too_close.insanity_effect = effect
    too_close.connect("inc_insanity", self, "insanity_change")
    add_child(too_close)

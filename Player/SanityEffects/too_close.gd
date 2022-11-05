class_name TooCloseSensibility
extends Area2D

signal inc_insanity(amt)

var too_fast: int
var insanity_effect: int
var coll_size_mult: float

var coll_shape: CollisionShape2D


func _init(speed_tol: int, insanity_eff: int, coll_s_mult: float):
    too_fast = speed_tol
    insanity_effect = insanity_eff
    coll_size_mult = coll_s_mult
    connect("body_entered", self, "_on_body_entered")
    name = "TooClose"

func _ready():
    var capsule = CapsuleShape2D.new()
    capsule.radius = 10 * coll_size_mult
    capsule.height = 20 * coll_size_mult
    coll_shape = CollisionShape2D.new()
    coll_shape.shape = capsule
    coll_shape.name = "CollisionShape2D"
    add_child(coll_shape)

func _on_body_entered(body:Node):
    if body.name == "Car":
        return # this needs to be solved with collision layers!!
    if Player.get_current_kph() > too_fast:
        emit_signal("inc_insanity", insanity_effect)

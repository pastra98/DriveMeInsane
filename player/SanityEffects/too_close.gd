class_name TooCloseSensibility
extends Area2D

signal inc_insanity(amt, reason)
onready var player = $"/root/Main".player

var too_fast: int
var insanity_effect: int
var coll_size_mult: float

var collider: CollisionShape2D


func _init(speed_tol: int, insanity_eff: int, coll_s_mult: float):
    too_fast = speed_tol
    insanity_effect = insanity_eff
    coll_size_mult = coll_s_mult
    connect("body_entered", self, "_on_body_entered")
    name = "TooClose"

func _ready():
    # if the collider needs to be visualized, this can be enabled in the debug menu
    var capsule_shape = CapsuleShape2D.new()
    capsule_shape.height = 20 * coll_size_mult
    capsule_shape.radius = 10 * coll_size_mult
    collider = CollisionShape2D.new()
    collider.shape = capsule_shape
    collider.name = "TooCloseCollider"
    add_child(collider)

func _on_body_entered(body:Node):
    if body.name == "Car":
        return # this needs to be solved with collision layers!!
    if player.get_current_kph() > too_fast:
        emit_signal("inc_insanity", insanity_effect, "Too close!!")

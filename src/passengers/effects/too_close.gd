class_name TooCloseSensibility
extends Area2D

signal inc_insanity(amt, reason)
onready var player = $"/root/Main/Level".player

var too_fast: int
var coll_size_mult: float

var collider: CollisionShape2D

var insanity_effect: int
var cooldown: int
var is_on_cooldown = false

func _init(speed_tol: int, coll_s_mult: float, insanity_eff: int, cooldown_time: int):
    too_fast = speed_tol
    coll_size_mult = coll_s_mult
    insanity_effect = insanity_eff
    connect("body_entered", self, "_on_body_entered")
    cooldown = cooldown_time
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
    if body.is_in_group("static_env") and player.get_current_kph() > too_fast and not is_on_cooldown:
        emit_signal("inc_insanity", insanity_effect, "Too close!!")
        get_node(name + "Timer").start(cooldown)
        is_on_cooldown = true


func get_txt_description() -> String:
    return "%s: +%s insanity when close to other objects" % [name, insanity_effect]
    # TODO: need better descriptions


func cooldown_over():
    is_on_cooldown = false
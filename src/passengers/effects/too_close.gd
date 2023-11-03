class_name TooCloseSensibility
extends Area2D

signal change_insanity(amt, reason, is_broadcast)
@onready var player = $"/root/Main/Level".player

var too_fast: int
var coll_size_mult: float

var collider: CollisionShape2D

var insanity_effect: float
var cooldown: int
var is_on_cooldown = false

func _init(speed_tol: int, coll_s_mult: float, insanity_eff: float, cooldown_time: int):
    too_fast = speed_tol
    coll_size_mult = coll_s_mult
    insanity_effect = insanity_eff
    connect("body_entered", Callable(self, "_on_body_entered"))
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
        emit_signal("change_insanity", insanity_effect, "Too close!!", false)
        get_node(name + "Timer").start(cooldown)
        is_on_cooldown = true


func get_txt_description() -> String:
    return "%s:\n+%s insanity when close to other objects and going faster than %s kph" % [name, insanity_effect, too_fast]


func cooldown_over():
    is_on_cooldown = false

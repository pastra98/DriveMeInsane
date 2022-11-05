extends Area2D

signal inc_insanity(amt)

var speed_tolerance: int = 0 # will need to find better way of instantiating stuff
var insanity_effect: int = 0 # will need to find better way of instantiating stuff

func _ready():
    if speed_tolerance == 0 or insanity_effect == 0:
        breakpoint



func _on_TooClose_body_entered(body:Node):
    # print(car_rb.linear_velocity)
    if Player.linear_velocity.length() > speed_tolerance:
        emit_signal("inc_insanity", insanity_effect)

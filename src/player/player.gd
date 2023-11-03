extends Node2D

signal new_health(health_lvl)
signal new_score(score_pts)
signal player_dead

const LV_TO_KPH = 0.1 # see google drive doc for how this value was derived

var health = 100
var score = 0
@onready var passengers = $Car/PassengerManager

func _ready():
    $"Car".connect("damage_taken", Callable(self, "take_damage"))


func get_current_kph() -> int:
    return int($"Car".linear_velocity.length() * LV_TO_KPH)


func take_damage(damage):
    health = max(0, health - damage)
    emit_signal("new_health", health)
    # play sounds and animations depending on damage level here
    if health == 0:
        score = 0
        explode()
        await get_tree().create_timer(2).timeout # wait
        emit_signal("player_dead")
    

func _on_raging_passenger(pass_name, rage_pts):
    # not sure if we actually need pass_name, other things can happen here to
    score += rage_pts
    emit_signal("new_score", score)


func explode():
    $"Car".disable()
    $"Car/Explosion".show() 
    $"Car/Explosion".play()
    $"Car/Sprite2D".hide()


func _on_Explosion_animation_finished():
    $"Car/Explosion".stop()
    $"Car/Explosion".hide()

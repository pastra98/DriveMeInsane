extends Node2D

signal new_health(health_lvl)
signal new_score(score_pts)
signal player_dead

const LV_TO_KPH = 0.1 # see google drive doc for how this value was derived
# initially wanted to make this an exponential func, but couldn't find good parameters. check gdrive for ggb file

# const DAMAGE_LEVELS = {5:0, 15:10, 20:15, 25:20, 30:30, 35:40, 40:50, 45:60, 50:75, 55:85, 60:100}
const DAMAGE_LEVELS = {5:0}

var health = 100
var score = 0
onready var passengers = $Car/PassengerManager

func _ready():
    pass


func _physics_process(delta): # testing
    $"Car/Label".text = str(get_current_kph())


func get_current_kph() -> int:
    return int($Car.linear_velocity.length() * LV_TO_KPH)


func _on_CollisionDetector_body_entered(body:Node):
    if body.is_in_group("static_env"):
        var curr_speed = get_current_kph()
        # this is kind of stupid, I'd rather have a continuous exponential func
        for speed in DAMAGE_LEVELS.keys():
            if curr_speed <= speed:
                take_damage(DAMAGE_LEVELS[speed])
                return


func take_damage(damage):
    health = max(0, health - damage)
    emit_signal("new_health", health)
    # play sounds and animations depending on damage level here
    if health == 0:
        score = 0
        explode()
        yield(get_tree().create_timer(2), "timeout") # wait
        emit_signal("player_dead")
    

func _on_raging_passenger(pass_name, rage_pts):
    # not sure if we actually need pass_name, other things can happen here to
    score += rage_pts
    emit_signal("new_score", score)


func explode():
    # TODO: stop receiving player input, freeze car..
    $"Car/Explosion".show() 
    $"Car/Explosion".play()
    $"Car/Sprite".hide()


func _on_Explosion_animation_finished():
    $"Car/Explosion".stop()
    $"Car/Explosion".hide()

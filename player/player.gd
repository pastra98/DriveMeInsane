extends Node2D

signal new_player_health(health_lvl)
signal player_dead

const LV_TO_KPH = 0.1 # see google drive doc for how this value was derived
# initially wanted to make this an exponential func, but couldn't find good parameters. check gdrive for ggb file
const DAMAGE_LEVELS = {5:0, 15:10, 20:15, 25:20, 30:30, 35:40, 40:50, 45:60, 50:75, 55:85, 60:100}

var health = 100


func _ready():
    add_passenger("bob")


func _physics_process(delta): # testing
    $Car/Label.text = str(get_current_kph())


func get_current_kph() -> int:
    return int($Car.linear_velocity.length() * LV_TO_KPH)


func add_passenger(passenger_name: String):
    var new_passenger = Passenger.new(passenger_name)
    $Car/PassengerManager.add_child(new_passenger)
    GuiManager.add_passenger_window(new_passenger)


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
    emit_signal("new_player_health", health)
    # play sounds and animations depending on damage level here
    if health == 0:
        emit_signal("player_dead")
    

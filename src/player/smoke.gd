extends CPUParticles2D

onready var player = get_node("/root/Main/Level/PlayerPos/Player")

# yes, this is very verbose and could have been done using a single array,
# but for readability purposes it's like this

# Amount scaling was initially tried, however Godot resets all particles after
# changing particle amount

var initial_lifetime = lifetime
var initial_scale = scale_amount 
var initial_spread = spread

const max_lifetime = 0.8
const max_scale = 40
const max_spread = 20

const top_speed = 50

func _ready():
    pass 

func _process(delta):
    set_lifetime(calculate_smoke(initial_lifetime, max_lifetime))
    set_param(PARAM_SCALE, calculate_smoke(initial_scale, max_scale))
    set_spread(calculate_smoke(initial_spread, max_spread))


func calculate_smoke(initial, maximum):
    var scale_speed = player.get_current_kph() / float(top_speed)
    var factor = (maximum / float(initial) - 1) * scale_speed + 1
    return initial * factor
    

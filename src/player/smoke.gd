extends CPUParticles2D

onready var player = $"../../.."

# yes, this is very verbose and could have been done using a single array,
# but for readability purposes it's like this
# Amount scaling was initially tried, however Godot resets all particles after
# changing particle amount

const MIN_LIFETIME: float = 0.5
const MIN_SCALE: float = 1.0
const MIN_SPREAD: float = 45.0 

const MAX_LIFETIME: float = 1.0
const MAX_SCALE: float = 40.0
const MAX_SPREAD: float = 20.0

const TOP_SPEED: float = 70.0

var t = 0

func _process(delta):
    t += delta
    if t > 0.1:
        var speed_scale = player.get_current_kph() / TOP_SPEED
        lifetime = lerp(MIN_LIFETIME, MAX_LIFETIME, speed_scale)
        scale_amount = lerp(MIN_SCALE, MAX_SCALE, speed_scale)
        spread = lerp(MIN_SPREAD, MAX_SPREAD, speed_scale)
        t = 0

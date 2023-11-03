extends Control

@onready var level_timer = $"/root/Main/Level/Timer"
@onready var player = $"/root/Main/Level".player
@onready var needle = $"Speedometer/Needle"

var beepsound = load("res://audio/sounds/beep.wav")
var time_fmt = "[center]%d:%02d"
var prev_t: int = 100000 # don't question it
var countdown_finished = false

const MIN_ANGLE = deg_to_rad(-85)
const MAX_ANGLE = deg_to_rad(85)

func _process(delta):
    var cur_t: int = ceil(level_timer.time_left)
    if countdown_finished:
        if cur_t < prev_t:
            var time = time_fmt % [cur_t / 60, cur_t % 60 % 60] 
            prev_t = cur_t
            if cur_t <= 10:
                time = "[color=red]" + time
                $"Beep".play()
            $"TimeLabel".text = time
    else:
        $"TimeLabel".text = "[center][color=green]" + str(cur_t)
    # update needle
    needle.set_rotation(lerp_angle(MIN_ANGLE, MAX_ANGLE, player.get_current_kph()/80.0))

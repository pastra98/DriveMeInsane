extends Control

onready var level_timer = $"/root/Main/Level/Timer"
var beepsound = load("res://audio/sounds/beep.wav")
var time_fmt = "[center]%d:%02d"
var prev_t: int = 100000 # don't question it
var countdown_finished = false

func _process(delta):
    var cur_t: int = ceil(level_timer.time_left)
    if countdown_finished:
        if cur_t < prev_t:
            var time = time_fmt % [cur_t / 60, cur_t % 60 % 60] 
            prev_t = cur_t
            if cur_t <= 10:
                time = "[color=red]" + time
                $"Beep".play()
            $"TimeLabel".bbcode_text = time
    else:
        $"TimeLabel".bbcode_text = "[center][color=green]" + str(cur_t)

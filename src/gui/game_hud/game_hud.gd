extends Control

onready var level_timer = $"/root/Main/Level/Timer"

func _process(delta):
    # TODO: write this intelligently
    if level_timer.time_left < 10:
        $"TimeLabel".bbcode_text = "[color=red][center]%d:%02d" % [floor(level_timer.time_left / 60), int(ceil(level_timer.time_left)) % 60 % 60]
    else:
        $"TimeLabel".bbcode_text = "[center]%d:%02d" % [floor(level_timer.time_left / 60), int(ceil(level_timer.time_left)) % 60 % 60]

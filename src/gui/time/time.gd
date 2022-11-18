extends Label

onready var level_timer = $"/root/Main/Level/Timer"

func _process(delta):
    text = "%d:%02d" % [floor(level_timer.time_left / 60), int(ceil(level_timer.time_left)) % 60 % 60]
    # TODO: make text red once under 10 seconds
    # TODO: this can actually be a script without a whole scene attached to it

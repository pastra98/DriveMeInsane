extends AudioStreamPlayer

const TRANS_DUR = 0.5

var base_volume = -50
var is_muted = false

var main_theme = preload("res://audio/music/main_theme.wav")
var game_theme = preload("res://audio/music/game_theme.wav")

var trans_type = 1 # TRANS_SINE


func switch_music(title: String):
    stop()
    if title == "main":
        stream = main_theme
        base_volume = -50
    elif title == "game":
        stream = game_theme
        base_volume = -40
    else:
        print("Sound not found"); breakpoint


func playback(resume: bool):
    if is_muted: # this is set by mute_music.gd, really shitty design, no time to come up with something better
        stop()
        return
    if resume:
        play()
        $"Tween".interpolate_property(self, "volume_db", -80, base_volume, TRANS_DUR, trans_type, Tween.EASE_IN, 0)
        $"Tween".start()
    else:
        $"Tween".interpolate_property(self, "volume_db", base_volume, -80, TRANS_DUR, trans_type, Tween.EASE_IN, 0)
        $"Tween".start()
        yield($"Tween", "tween_completed")
        stop()


func button_sound():
    # for now just put it here, this is all last-day hacks
    $"ButtonSound".play()

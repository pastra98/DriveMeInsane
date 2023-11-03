extends AudioStreamPlayer

const TRANS_DUR = 0.5

var base_volume = -50 # TODO: fix this shit
var is_muted = false

var main_theme = preload("res://audio/music/main_theme.wav")
var game_theme = preload("res://audio/music/game_theme.wav")

@onready var music_tween = get_tree().create_tween()


func _ready():
    music_tween.set_ease(Tween.EASE_IN)
    music_tween.set_trans(Tween.TRANS_SINE)


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
        music_tween.tween_property($Path2D/PathFollow2D, "progress_ratio", base_volume, TRANS_DUR)
    else:
        music_tween.tween_property($Path2D/PathFollow2D, "progress_ratio", -80, TRANS_DUR)
        await music_tween.finished
        stop()


func button_sound():
    # for now just put it here, this is all last-day hacks
    $"ButtonSound".play()

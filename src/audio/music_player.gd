extends AudioStreamPlayer

"""
TODO:
- maybe play some radio changing sound when switching music
    - play the sound from another stream player node - maybe the player
        - this is because we might want to switch the music without it being a radio
        switch - e.g. changing from title menu to game
    - then play a button switch and maybe after that some radio static while the old
    sound fades out and the new one fades in
"""

const BASE_VOLUME = -50

var main_theme = preload("res://audio/music/main_theme.wav")
var game_theme = preload("res://audio/music/game_theme.wav")

var trans_dur = 1.00 # will
var trans_type = 1 # TRANS_SINE

var next_track

func _ready():
    pass


func switch_music(title: String):
    if title == "main":
        next_track = main_theme
    elif title == "game":
        next_track = game_theme
    else:
        print("Sound not found"); breakpoint
    # fade out
    $TweenOut.interpolate_property(self, "volume_db", BASE_VOLUME, -80, trans_dur/2, trans_type, Tween.EASE_IN, 0)
    $TweenOut.start()


func _on_TweenOut_tween_completed(object:Object, key:NodePath):
    stream = next_track
    playing = true
    $TweenIn.interpolate_property(self, "volume_db", -80, BASE_VOLUME, trans_dur/2, trans_type, Tween.EASE_IN, 0)
    $TweenIn.start()


func playback(resume: bool):
    # use tween in in both case cause it triggers no signals unlike tween out
    if resume:
        play()
        $TweenIn.interpolate_property(self, "volume_db", -80, BASE_VOLUME, trans_dur, trans_type, Tween.EASE_IN, 0)
    else:
        $TweenIn.interpolate_property(self, "volume_db", BASE_VOLUME, -80, trans_dur, trans_type, Tween.EASE_IN, 0)
        yield(get_tree().create_timer(trans_dur), "timeout") # somehow couldnt get tweenIn signal working here?? not enough time to fix proper
        stop()

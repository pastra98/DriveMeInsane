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

onready var main_theme = preload("res://audio/music/main_theme.wav")
onready var music2 = preload("res://audio/testing/Ensoniq-ZR-76-African-LP.wav")

var trans_dur = 1.00 # will
var trans_type = 1 # TRANS_SINE

var next_track

func _ready():
    pass


func _unhandled_input(event): # not sure if this stuff should be handled here, for now it is just testing
    if event is InputEventKey and event.pressed:
        # track
        if event.scancode == KEY_1:
            switch_music(main_theme)
        elif event.scancode == KEY_2:
            switch_music(music2)
        # 
        if event.scancode == KEY_F:
            stop()
        elif event.scancode == KEY_A:
            play()


func switch_music(title):
    next_track = title
    # fade out
    $TweenOut.interpolate_property(self, "volume_db", 0, -80, trans_dur/2, trans_type, Tween.EASE_IN, 0)
    $TweenOut.start()


func _on_TweenOut_tween_completed(object:Object, key:NodePath):
    stream = next_track
    playing = true
    $TweenIn.interpolate_property(self, "volume_db", -80, 0, trans_dur/2, trans_type, Tween.EASE_IN, 0)
    $TweenIn.start()

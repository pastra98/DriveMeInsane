extends TextureButton

# normally this should all be done in the main menu gui thing, just running out of time here

func _on_TextureButton_button_down():
    if not MusicPlayer.is_muted:
        MusicPlayer.is_muted = true
        MusicPlayer.playback(false)
        texture_normal = load("res://gui/main_menu/muted.png")
        texture_hover = load("res://gui/main_menu/unmuted.png")
        texture_pressed = load("res://gui/main_menu/unmuted.png")
    else:
        MusicPlayer.is_muted = false
        MusicPlayer.playback(true)
        texture_normal = load("res://gui/main_menu/unmuted.png")
        texture_hover = load("res://gui/main_menu/muted.png")
        texture_pressed = load("res://gui/main_menu/muted.png")

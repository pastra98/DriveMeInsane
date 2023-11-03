extends MarginContainer

signal new_level_picked(lvl_nr)
@onready var main = get_node("/root/Main")

func _ready():
    var dir = DirAccess.open("res://environment/levels")
    dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
    var file_name = dir.get_next()
    while file_name != "":
        if not dir.current_is_dir() and file_name.get_extension() == "tscn":
            var lvl_nr = int(file_name.get_basename().lstrip("Level"))
            var new_button = Button.new()
            new_button.text = str(lvl_nr)
            if lvl_nr == 1 or main.completed_lvls.has(lvl_nr-1): # lvl 1 is unlock, so is any lvl where prev lvl is passed
                new_button.icon = load("res://gui/main_menu/level_picker/unlocked.png")
            else:
                new_button.icon = load("res://gui/main_menu/level_picker/locked.png")
                new_button.disabled = true
            new_button.connect("pressed", Callable(self, "level_button_pressed").bind(lvl_nr))
            $"Panel/VBoxContainer/VBoxContainer".add_child(new_button)
        file_name = dir.get_next()


func level_button_pressed(lvl_nr):
    MusicPlayer.button_sound()
    emit_signal("new_level_picked", lvl_nr)
    queue_free()

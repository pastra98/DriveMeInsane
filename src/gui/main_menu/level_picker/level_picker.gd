extends MarginContainer

signal new_level_picked(lvl_nr)
onready var main = get_node("/root/Main")

func _ready():
    var dir = Directory.new()
    dir.open("res://environment/levels")
    dir.list_dir_begin()
    var file_name = dir.get_next()
    while file_name != "":
        if not dir.current_is_dir() and file_name.get_extension() == "tscn":
            var lvl_nr = int(file_name.get_basename().lstrip("Level"))
            var new_button = Button.new()
            new_button.text = String(lvl_nr)
            if lvl_nr == 1 or main.completed_lvls.has(lvl_nr-1): # lvl 1 is unlock, so is any lvl where prev lvl is passed
                new_button.icon = load("res://gui/main_menu/level_picker/unlocked.png")
            else:
                new_button.icon = load("res://gui/main_menu/level_picker/locked.png")
                new_button.disabled = true
            new_button.connect("pressed", self, "level_button_pressed", [lvl_nr])
            $"Panel/VBoxContainer/VBoxContainer".add_child(new_button)
        file_name = dir.get_next()


func level_button_pressed(lvl_nr):
    emit_signal("new_level_picked", lvl_nr)
    queue_free()

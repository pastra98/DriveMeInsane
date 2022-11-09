extends Node2D

var player
var curr_lvl

onready var bg_scene = load("res://environment/menu_background/BackgroundLevel.tscn").instance()

func _ready():
    add_child(bg_scene)
    GuiManager.add_level_picker()


func load_level(level_nr):
    # first remove all children of the main node - thus far should only be level
    for child in get_children():
        child.queue_free()
    match level_nr:
        1:
            curr_lvl = load("res://environment/level_1/Level1.tscn").instance()
        2:
            print("2")
    add_child(curr_lvl)
    player = load("res://player/Player.tscn").instance()
    curr_lvl.get_node("PlayerPos").add_child(player)
    GuiManager.remove_level_picker()
    # TODO: add prepare gui also once a level is chosen (show player health etc)

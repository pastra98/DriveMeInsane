extends Node2D

var curr_lvl
# ["ahote", "bjorn", "bob", "hiroshi", "izaak", "juan", "karen", "lucy", "martha", "mike", "xiu"]
var unlocked_passengers = ["ahote", "bjorn", "bob", "hiroshi", "izaak", "juan", "karen", "lucy", "martha", "mike", "xiu"]
var completed_lvls = {}

onready var bg_scene = load("res://environment/menu_background/BackgroundLevel.tscn").instance()

func _ready():
    add_child(bg_scene)
    GuiManager.add_level_picker()


func load_level(level_nr):
    # first remove all children of the main node - thus far should only be level
    for child in get_children():
        child.queue_free()
    # TODO: maybe at some point replace match statement with a string format that loads scene - keep level names coherent
    match level_nr:
        1:
            curr_lvl = load("res://environment/level_1/Level1.tscn").instance()
        2:
            print("2")
    add_child(curr_lvl)
    curr_lvl.prepare_level(unlocked_passengers)


func _on_level_completed(level_nr, pts):
    if completed_lvls.has(level_nr):
        if completed_lvls[level_nr] < pts:
            completed_lvls[level_nr] = pts
    else:
        completed_lvls[level_nr] = pts

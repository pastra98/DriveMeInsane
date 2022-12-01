extends Node2D

var curr_lvl
# ["ahote", "bjorn", "bob", "hiroshi", "karl", "juan", "karen", "lucy", "martha", "mike", "xiu", "marvin", "karli", "merlin"]
# var unlocked_passengers = ["bob", "karen", "lucy", "marvin", "bjorn", "martha", "merlin", "karli"]

var unlocked_passengers = ["bob"]
var completed_lvls = {}

var n_lvls = 5 # TODO: this should also be set dynamically, game_over.gd depends on this to show next level
var is_tutorial_completed = false

func _ready():
    GuiManager.show_main_menu()


func load_level(level_nr):
    # first remove all children of the main node - thus far should only be level
    for child in get_children():
        child.free() # can't use queue free cause it won't delete b4 loading next lvl
    # TODO: maybe at some point replace match statement with a string format that loads scene - keep level names coherent
    curr_lvl = load("res://environment/levels/Level%s.tscn" % level_nr).instance()
    add_child(curr_lvl)
    curr_lvl.prepare_level(unlocked_passengers)


func _on_level_completed(level_nr: int, pts: int, new_passengers_name: Array):
    if completed_lvls.has(level_nr): # level already unlocked
        if completed_lvls[level_nr] < pts:
            completed_lvls[level_nr] = pts
    else: # level unlocked first time
        completed_lvls[level_nr] = pts
        if new_passengers_name:
            unlocked_passengers += new_passengers_name

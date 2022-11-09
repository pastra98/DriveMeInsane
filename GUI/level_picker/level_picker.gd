extends MarginContainer

"""
TODO:
- make it more procedural, able to add new buttons for levels based on code, also
  don't hardcode a function for every button obviously.
"""

signal new_level_picked(lvl_nr)

func _ready():
    $Panel/VBoxContainer/Lvl1.connect("button_down", self, "_on_lvl1_button_down")
    pass


func _on_lvl1_button_down():
    emit_signal("new_level_picked", 1)

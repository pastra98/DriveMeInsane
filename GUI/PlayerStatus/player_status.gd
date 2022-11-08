extends MarginContainer


onready var bar = $HBoxContainer/Health


func update_health(new_value):
    bar.value = new_value

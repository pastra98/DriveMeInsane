class_name AllGasNoBrakes
extends Node2D

@onready var car = $"../../.."

var required_insanity: int


func _init(insanity_req: int):
    # passenger = get_parent()
    required_insanity = insanity_req
    name = "AllGasNoBrakes"


func _on_new_insanity(new_insanity: int, _reason: String):
    if new_insanity >= required_insanity:
        car.all_gas_no_brakes = true
    else:
        car.all_gas_no_brakes = false

func get_txt_description() -> String:
    return "%s:\nIf the passenger reaches insanity level %s, he will prevent you from slowing down the car or hitting the brakes" % [name, required_insanity]
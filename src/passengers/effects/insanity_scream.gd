class_name InsanityScream
extends Node2D

signal change_insanity(amt, reason, is_broadcast)

var insanity_effect: int

func _init(insanity_eff: int):
    insanity_effect = insanity_eff
    name = "InsanityScream"

func _on_passenger_raging(): # gets triggered by signal, connected in passenger.gd
    # wait 1 sec b4 emitting broadcast
    yield(get_tree().create_timer(1), "timeout")
    emit_signal("change_insanity", insanity_effect, "Loud scream!", true)

func get_txt_description() -> String:
    return "%s:\n+%s insanity when passenger Screams. Screams when on full insanity" % [name, insanity_effect]

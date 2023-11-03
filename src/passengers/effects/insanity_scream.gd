class_name InsanityScream
extends Node2D

signal change_insanity(amt, reason, is_broadcast)

var insanity_effect: float

func _init(insanity_eff: float):
    insanity_effect = insanity_eff
    name = "InsanityScream"

func _on_passenger_raging(_pass_name, _rage_pts): # gets triggered by signal, connected in passenger.gd
    # wait 1 sec b4 emitting broadcast
    await get_tree().create_timer(1).timeout
    emit_signal("change_insanity", insanity_effect, "Loud scream!", true)

func get_txt_description() -> String:
    return "%s:\n+%s insanity for all passengers when on full insanity" % [name, insanity_effect]

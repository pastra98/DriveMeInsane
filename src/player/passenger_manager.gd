extends Node2D


func _ready():
    pass # Replace with function body.


func change_everyones_insanity(responsible_passenger: Passenger, change_by: int, reason: String):
    print("heya")
    for passenger in get_children():
        if passenger != responsible_passenger:
            passenger.insanity_change(change_by, reason, false)

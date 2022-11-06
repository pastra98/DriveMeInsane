extends MarginContainer

onready var bar = $Bars/LifeBar/TextureProgress
var passengers = []


func _ready():	
    pass # Replace with function body.

func add_passenger(passenger_path: String, passenger_insanity):
    var passenger = load("res://GUI/Bar.tscn").instance(passenger_path, passenger_insanity)
    $Bars.add_child(passenger)
    passengers.append(passenger)

func update_passenger(passenger_name: String, passenger_insanity):
    for passenger in passengers:
        if passenger.name == passenger_name:
            passenger.update_insanity(passenger_insanity)

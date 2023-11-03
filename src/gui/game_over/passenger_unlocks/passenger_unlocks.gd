extends MarginContainer

var unlocked_passengers = []

func _ready():
    pass # Replace with function body.


func show_passengers(unlocked_passenger_names: Array):
    for passenger_name in unlocked_passenger_names:
        var passenger = Passenger.new(passenger_name)
        var new_card = load("res://gui/before_level/passenger_picker/passenger_card/PassengerCard.tscn").instantiate()
        new_card.set_passenger(passenger)
        new_card.get_node("Panel/TopVBox/AddToCar").hide()
        $"Panel/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/UnlockList".add_child(new_card)
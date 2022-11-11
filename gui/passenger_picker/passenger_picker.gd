extends MarginContainer


func _ready():
    pass


func add_passenger_cards(passenger_instances: Array):
    for passenger in passenger_instances:
        var new_card = load("res://gui/passenger_picker/passenger_card/PassengerCard.tscn").instance()
        new_card.set_passenger(passenger)
        new_card.connect("passenger_added_to_player", self, "seat_passenger")
        $Panel/MarginContainer/VBoxContainer/ScrollContainer/PickList.add_child(new_card)


func seat_passenger(passenger_name: String):
    print(passenger_name)
    # update picture above
    # notify level to move node instance in tree from Available to Player

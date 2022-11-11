extends MarginContainer

signal all_passengers_seated

onready var seats = $"Panel/MarginContainer/VBoxContainer/Seats"
onready var level = $"/root/Main/Level"

var curr_seated = 0
var all_seated = false

func _ready():
    print(level)
    breakpoint
    pass


func add_passenger_cards(passenger_instances: Array):
    for passenger in passenger_instances:
        var new_card = load("res://gui/passenger_picker/passenger_card/PassengerCard.tscn").instance()
        new_card.set_passenger(passenger)
        connect("all_passengers_seated", new_card, "_on_all_passengers_seated")
        new_card.connect("passenger_added_to_player", self, "seat_passenger")
        # new_card.connect("passenger_added_to_player", self, "seat_passenger")
        $"Panel/MarginContainer/VBoxContainer/ScrollContainer/PickList".add_child(new_card)


func seat_passenger(passenger_ref: Passenger):
    # check if all seats already full
    if all_seated:
        return
    # update texture button
    var curr_seat = seats.get_child(curr_seated)
    curr_seated += 1
    if curr_seated == 4:
        emit_signal("all_passengers_seated")
        all_seated = true
    # update picture above
    # notify level to move node instance in tree from Available to Player

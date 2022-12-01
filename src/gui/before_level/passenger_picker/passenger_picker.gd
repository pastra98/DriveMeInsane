extends MarginContainer

signal all_passengers_seated
signal free_seats_available
signal level_started

onready var seats = $"Panel/MarginContainer/VBoxContainer/Seats"
onready var level = $"/root/Main/Level"
onready var picklist = $"Panel/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/PickList"

var n_seated = 0
# TODO: find a cleaner solution, I just can't be assed now
var seat_config = {"CarSeat1": null, "CarSeat2": null, "CarSeat3": null, "CarSeat4": null}


func add_passenger_cards(passenger_instances: Array):
    # passenger picker needs to be in tree for this to work bc. it can't make connections to level else
    for passenger in passenger_instances:
        var new_card = load("res://gui/before_level/passenger_picker/passenger_card/PassengerCard.tscn").instance()
        new_card.set_passenger(passenger)
        connect("all_passengers_seated", new_card, "_on_all_passengers_seated")
        connect("free_seats_available", new_card, "_on_free_seats_available")
        new_card.connect("passenger_added_to_player", self, "seat_passenger")
        new_card.connect("passenger_added_to_player", level, "add_passenger_to_player")
        $"Panel/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/PickList".add_child(new_card)
    for seat in seats.get_children():
        seat.connect("passenger_removed_from_player", self, "unseat_passenger")
        seat.connect("passenger_removed_from_player", level, "remove_passenger_from_player")


func seat_passenger(passenger_ref: Passenger):
    MusicPlayer.button_sound()
    $"Panel/MarginContainer/VBoxContainer/HBoxContainer2/StartLevel".disabled = false
    # update texture button
    n_seated = 0
    for seat_name in seat_config:
        n_seated += 1
        if seat_config[seat_name] == null:
            seat_config[seat_name] = passenger_ref
            seats.get_node(seat_name).update_seat(passenger_ref)
            break
    # TODO: this whole thing can surely be done much better
    if n_seated == seats.get_child_count():
        emit_signal("all_passengers_seated")


func unseat_passenger(passenger_ref: Passenger, seat_name: String):
    # TODO: fix n_seated for removing passengers, it is still broken
    n_seated -= 1
    if n_seated == 0:
        $"Panel/MarginContainer/VBoxContainer/HBoxContainer2/StartLevel".disabled = true
    MusicPlayer.button_sound()
    seat_config[seat_name] = null
    picklist.get_node(passenger_ref.name + "Card").show()
    emit_signal("free_seats_available")


func _on_StartLevel_button_down():
    # TODO: can do some checks on how many people need to be seated for lvl, grey out button before
    MusicPlayer.button_sound()
    emit_signal("level_started")


func _on_BackToMain_button_down():
    MusicPlayer.button_sound()
    GuiManager.show_main_menu()

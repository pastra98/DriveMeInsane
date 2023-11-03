extends MarginContainer

signal passenger_added_to_player(pass_ref) # triggers stuff in level.gd and passenger_picker.gd

var passenger_ref: Passenger


func _ready():
    if not passenger_ref: # check if passenger has been set b4 entering tree
        print("no passenger has been set for this card!"); breakpoint


func set_passenger(passenger_instance: Passenger):
    passenger_ref = passenger_instance
    name = passenger_ref.name + "Card"
    $"Panel/TopVBox/HBoxContainer/VBoxContainer/Name".text = passenger_ref.name
    $"Panel/TopVBox/HBoxContainer/Lore".text = passenger_ref.lore
    $"Panel/TopVBox/HBoxContainer/VBoxContainer/Effects".text = passenger_ref.get_sensibilities_txt()
    $"Panel/TopVBox/HBoxContainer/VBoxContainer/CenterContainer/PassengerPic".texture = load(passenger_ref.imgpath % "happy")


func _on_AddToCar_button_down():
    emit_signal("passenger_added_to_player", passenger_ref)
    # TODO: this now no longer works cause they're not in the tree b4 the game starts
    # passenger_ref.scream()
    hide()


func _on_all_passengers_seated():
    $"Panel/TopVBox/AddToCar".disabled = true

func _on_free_seats_available():
    $"Panel/TopVBox/AddToCar".disabled = false

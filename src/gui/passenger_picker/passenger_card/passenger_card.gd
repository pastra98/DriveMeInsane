extends MarginContainer

signal passenger_added_to_player(pass_ref) # triggers stuff in level.gd and passenger_picker.gd

var passenger_ref: Passenger


func _ready():
    if not passenger_ref: # check if passenger has been set b4 entering tree
        print("no passenger has been set for this card!"); breakpoint


func set_passenger(passenger_instance: Passenger):
    passenger_ref = passenger_instance
    name = passenger_ref.name + "Card"
    $"Panel/TopVBox/Name".text = passenger_ref.name
    $"Panel/TopVBox/Lore".bbcode_text = "[center]%s[/center]" % passenger_ref.lore
    $"Panel/TopVBox/Effects".bbcode_text = "[center]%s[/center]" % passenger_ref.get_sensibilities_txt()
    $"Panel/TopVBox/CenterContainer/PassengerPic".texture = load(passenger_ref.imgpath % "happy")


func _on_AddToCar_button_down():
    emit_signal("passenger_added_to_player", passenger_ref)
    hide()
    # TODO: need to show again if passenger is removed from selection


func _on_all_passengers_seated():
    $"Panel/TopVBox/AddToCar".disabled = true

func _on_free_seats_available():
    $"Panel/TopVBox/AddToCar".disabled = false

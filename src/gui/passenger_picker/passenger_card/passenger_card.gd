extends MarginContainer

signal passenger_added_to_player(pass_name)

var passenger_name: String


func _ready():
    if not passenger_name: # check if passenger has been set b4 entering tree
        print("no passenger has been set for this card!"); breakpoint


func set_passenger(passenger_instance: Passenger):
    passenger_name = passenger_instance.name
    name = passenger_instance.name + "Card"
    $Panel/TopVBox/Name.text = passenger_name
    $Panel/TopVBox/Lore.bbcode_text = "[center]%s[/center]" % passenger_instance.lore
    $Panel/TopVBox/Effects.bbcode_text = "[center]%s[/center]" % passenger_instance.get_sensibilities_txt()
    $Panel/TopVBox/CenterContainer/PassengerPic.texture = load(passenger_instance.imgpath % "happy")


func _on_AddToCar_button_down():
    emit_signal("passenger_added_to_player", passenger_name)
    hide()
    # TODO: need to show again if passenger is removed from selection

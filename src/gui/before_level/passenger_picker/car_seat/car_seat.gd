extends VBoxContainer

signal passenger_removed_from_player(pass_ref, seat_name)

@onready var button_container = $VBoxContainer

var passenger_ref: Passenger

func _ready():
    pass

func _on_RemoveSeat_button_down():
    if passenger_ref != null:
        $Label.text = "Nobody"
        $RemoveSeat.texture_normal = load("res://passengers/ressources/nobody.png")
        emit_signal("passenger_removed_from_player", passenger_ref, name)
        passenger_ref = null


func update_seat(passenger_instance):
    passenger_ref = passenger_instance
    $Label.text = passenger_ref.name
    $RemoveSeat.texture_normal = load(passenger_ref.imgpath % "happy")

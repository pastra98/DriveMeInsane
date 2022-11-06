extends Node2D

signal passenger_added(name, imgpath, insanity)


func _ready():
    add_passenger("Bob")
    connect("passenger_added", GuiManager, "add_passenger_window")


func _physics_process(delta): # testing
    $Car/Label.text = str(get_current_kph())


func get_current_kph() -> float:
    return $Car.linear_velocity.length() / 5


func add_passenger(passenger_name: String):
    var new_passenger = Passenger.new(passenger_name)
    $Car/PassengerManager.add_child(new_passenger)
    emit_signal(
        "passenger_added",
        "res://Player/Passengers/%s.png" % passenger_name,
        new_passenger
        )

# andere idee: ich schicke hier eine reference zu passenger mit. diese wird im gui manager nur verwendet um eine connection vom passenger zum guiPassengerWindow zu machen. Die connection wird also durchs gui gemacht. danach wird die reference nie wieder verwendet.
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
    add_passenger("Bob")


func _physics_process(delta): # testing
    $Car/Label.text = str(get_current_kph())


func get_current_kph() -> float:
    return $Car.linear_velocity.length() / 5


func add_passenger(passenger_name: String):
    var new_passenger = Passenger.new(passenger_name)
    $Car/PassengerManager.add_child(new_passenger)

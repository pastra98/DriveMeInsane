extends CanvasLayer

func _ready():	
    # set_follow_viewport(true)
    pass # Replace with function body.


func add_passenger_window(imgpath: String, passenger):
    var passenger_window = load("res://Gui/PassengerWindow/PassengerWindow.tscn").instance()
    passenger.connect("new_insanity", passenger_window, "update_insanity")
    passenger.connect("new_picture", passenger_window, "update_picture")
    $MarginContainer/Bars.add_child(passenger_window)
    passenger_window.update_insanity(passenger.insanity, "Lets start!")
    passenger_window.update_picture(passenger.imgpath % "1")

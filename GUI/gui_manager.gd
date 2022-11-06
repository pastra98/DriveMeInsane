extends CanvasLayer

func _ready():	
    # set_follow_viewport(true)
    pass # Replace with function body.


func add_passenger_window(imgpath: String, passenger):
    var passenger_window = load("res://GUI/PassengerWindow.tscn").instance()
    passenger_window.insanity = passenger.insanity
    passenger_window.imgpath = passenger.imgpath
    passenger.connect("new_insanity", passenger_window, "update_insanity")
    # passenger.connect("change_picture", passenger_window, "update_picture")
    $MarginContainer/Bars.add_child(passenger_window)

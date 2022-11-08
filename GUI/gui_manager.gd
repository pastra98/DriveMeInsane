extends CanvasLayer

onready var player = $"/root/Level/Player"
onready var player_status = $"PlayerStatus"

func _ready():	
    player.connect("new_player_health", player_status, "update_health")


func add_passenger_window(imgpath: String, passenger):
    var passenger_window = load("res://Gui/PassengerWindow/PassengerWindow.tscn").instance()
    passenger.connect("new_insanity", passenger_window, "update_insanity")
    passenger.connect("new_picture", passenger_window, "update_picture")
    $PassengerMargin/PassengerContainer.add_child(passenger_window)
    passenger_window.update_insanity(passenger.insanity, "Lets start!")
    passenger_window.update_picture(passenger.imgpath % "1")

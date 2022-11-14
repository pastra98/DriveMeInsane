extends CanvasLayer

# since this is the only autoload singleton we have, just put stuff here for now
const MAX_PASSENGERS = 4 # TODO: maybe later find better solution

var player_status

func _ready():	
    pass


func add_passenger_window(passenger_ref):
    var passenger_window = load("res://gui/passenger_window/PassengerWindow.tscn").instance()
    passenger_ref.connect("new_insanity", passenger_window, "update_insanity")
    passenger_ref.connect("new_picture", passenger_window, "update_picture")
    $"PassengerMargin/PassengerContainer".add_child(passenger_window)
    passenger_window.update_insanity(passenger_ref.insanity, "Lets start!")
    passenger_window.update_picture(passenger_ref.imgpath % "happy")


func add_player_status(player):
    player_status = load("res://gui/player_status/PlayerStatus.tscn").instance()
    player.connect("new_player_health", player_status, "update_health")
    add_child(player_status)


func add_level_picker():
    var lvl_picker = load("res://gui/level_picker/LevelPicker.tscn").instance()
    lvl_picker.connect("new_level_picked", get_node("/root/Main"), "load_level")
    add_child(lvl_picker)


func add_passenger_picker(passenger_instances: Array):
    var pass_picker = load("res://gui/passenger_picker/PassengerPicker.tscn").instance()
    add_child(pass_picker) # needs to be caled b4 adding passengers
    pass_picker.add_passenger_cards(passenger_instances)
    pass_picker.connect("level_started", $"/root/Main/Level", "start_level")

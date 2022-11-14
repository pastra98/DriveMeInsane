extends CanvasLayer

# since this is the only autoload singleton we have, just put stuff here for now
const MAX_PASSENGERS = 4 # TODO: maybe later find better solution

var player_status

func _ready():	
    pass

# ---------- UI WHILE DRIVING IN LEVEL ----------

func load_game_hud(player: Node2D, passenger_refs_arr: Array):
    # set's up the UI elements needed during gameplay
    $"PassengerPicker".queue_free()
    # add player status
    player_status = load("res://gui/player_status/PlayerStatus.tscn").instance()
    player.connect("new_player_health", player_status, "update_health")
    add_child(player_status)
    # add the passenger windows
    for passenger_ref in passenger_refs_arr:
        var new_passenger_window = load("res://gui/passenger_window/PassengerWindow.tscn").instance()
        passenger_ref.connect("new_insanity", new_passenger_window, "update_insanity")
        passenger_ref.connect("new_picture", new_passenger_window, "update_picture")
        $"PassengerMargin/PassengerContainer".add_child(new_passenger_window)
        new_passenger_window.update_insanity(passenger_ref.insanity, "Lets start!")
        new_passenger_window.update_picture(passenger_ref.imgpath % "happy")
    # add time and score
    var time_score = load("res://gui/time_and_score/TimeAndScore.tscn").instance()
    add_child(time_score)

# ---------- PASSENGER PICKER ----------

func add_passenger_picker(passenger_refs_arr: Array):
    var pass_picker = load("res://gui/passenger_picker/PassengerPicker.tscn").instance()
    add_child(pass_picker) # needs to be caled b4 adding passengers
    pass_picker.add_passenger_cards(passenger_refs_arr)
    pass_picker.connect("level_started", $"/root/Main/Level", "start_level")

# ---------- LEVEL PICKER ----------

func add_level_picker():
    var lvl_picker = load("res://gui/level_picker/LevelPicker.tscn").instance()
    lvl_picker.connect("new_level_picked", get_node("/root/Main"), "load_level")
    add_child(lvl_picker)

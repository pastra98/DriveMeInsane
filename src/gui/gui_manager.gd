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
    player.connect("new_health", player_status, "update_health")
    player.connect("new_score", player_status, "update_score")
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
    var time_score = load("res://gui/time/time.tscn").instance()
    add_child(time_score)


func show_level_over_gui(lvl_nr: int, stars: int, next_lvl_unlock: bool, points: int):
    # first clear the in-game hud
    $"PlayerStatus".queue_free()
    for passenger_window in $"PassengerMargin/PassengerContainer".get_children():
        passenger_window.queue_free()
    $"Time".queue_free()
    # then show the game over screen
    var game_over_screen = load("res://gui/game_over/GameOver.tscn").instance()
    game_over_screen.setup(lvl_nr, stars, next_lvl_unlock, points)
    game_over_screen.connect("restart", $"/root/Main/Level", "restart_level")
    add_child(game_over_screen)
    # TODO: connect next level
    # TODO: also connect to options, this will trigger stuff in the gui manager
    # TODO: connect main menu

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

extends Node

signal level_completed(lvl_nr, pts)

export(int) var level_nr = null # very important for this to be identical with match statement in main
export(int) var points_1_star = null
export(int) var points_2_stars = null
export(int) var points_3_stars = null
export(int) var time_to_complete = null

var player: Node2D
onready var point_levels = [points_1_star, points_2_stars, points_3_stars]

var timer: Timer
var available_passengers: Node2D
var selected_passenger_names = []

onready var main = get_parent()

func _ready():
    # TODO: connect all other signals that trigger responsibilities of main
    connect("level_completed", main, "_on_level_completed")
    # do some checks here if the exports have been set by the scene
    for property in get_property_list():
        if property.usage == 8199 and get(property.name) == null:
            print("Property %s\nHas not been set in the inspector" % property.name); breakpoint
    # add container for passengers during level picking
    available_passengers = Node2D.new()
    available_passengers.name = "AvailablePassengers"
    add_child(available_passengers)
    # add timer node
    timer = Timer.new() # TODO: maybe later ticking sound when timer is low
    timer.name = "Timer"
    timer.connect("timeout", self, "_on_time_up")
    add_child(timer)

# ---------- BEFORE GAME STARTS ----------

func prepare_level(unlocked_passengers: Array):
    # make player instance - but don't add it to tree yet
    player = load("res://player/Player.tscn").instance()
    player.connect("player_dead", self, "_on_player_dead")
    # make passenger instances and add to container node (AvailablePassengers)
    var passenger_instances = []
    for passenger_name in unlocked_passengers:
        var new_passenger = Passenger.new(passenger_name)
        passenger_instances.append(new_passenger)
        available_passengers.add_child(new_passenger)
    GuiManager.add_passenger_picker(passenger_instances)


func add_passenger_to_player(passenger_ref: Passenger):
    available_passengers.remove_child(passenger_ref)
    player.get_node("Car/PassengerManager").add_child(passenger_ref)


func remove_passenger_from_player(passenger_ref: Passenger, _seat_name: String):
    # TODO: fix this- super hacky, seat name is not needed here but since we only use one signal for gui and level, we do it this way
    player.get_node("Car/PassengerManager").remove_child(passenger_ref)
    available_passengers.add_child(passenger_ref)

# ----------  GAME STARTS ----------

func start_level(): # probably is going to be triggered by button in picker
    # add player to tree
    $"PlayerPos".add_child(player)
    # free unused passengers that are still children of AvailablePassengers
    for passenger in available_passengers.get_children():
        passenger.queue_free()
    # connect selected passengers to player
    selected_passenger_names.clear() # needs to be cleared otherwise it grows every time level is restarted
    var passenger_refs = player.get_node("Car/PassengerManager").get_children()
    for passenger in passenger_refs:
        passenger.connect("passenger_raging", player, "_on_raging_passenger")
        selected_passenger_names.append(passenger.name)
    # set up the gui
    GuiManager.load_game_hud(player, passenger_refs)
    # delay a bit and then start timer
    # TODO: show some countdown and ticking noise here
    get_tree().paused = true
    yield(get_tree().create_timer(1), "timeout") 
    get_tree().paused = false
    timer.start(time_to_complete)

# ---------- GAME OVER ----------

func _on_player_dead():
    timer.stop()
    level_over(player.score) # should be set to 0 pts for crashing


func _on_time_up():
    timer.stop()
    level_over(player.score)


func level_over(points: int):
    player.queue_free() # needs to be done cause a new player instance is created every time a new level is made
    # TODO: check if enough points to pass or fail
    # figure out stars here
    var stars = 0
    for n_pts in point_levels:
        if points >= n_pts:
            stars += 1
    if stars > 0:
        emit_signal("level_completed", level_nr, points) # TODO: this just test - also only caught by main
    # this stuff afterwards
    var next_lvl_unlock = main.completed_lvls.has(level_nr)
    GuiManager.show_level_over_gui(level_nr, stars, next_lvl_unlock, points)


func restart_level():
    # prepare level again
    prepare_level(main.unlocked_passengers)
    #
    for passenger_name in selected_passenger_names:
        var passenger = available_passengers.get_node(passenger_name)
        # hacky: this stuff is normally triggered by a signal in passenger_card.gd
        GuiManager.get_node("PassengerPicker").seat_passenger(passenger)
        GuiManager.get_node("PassengerPicker").picklist.get_node(passenger_name + "Card").hide()
        add_passenger_to_player(passenger)

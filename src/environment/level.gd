extends Node

signal level_completed(lvl_nr, pts)

export(int) var points_1_star = null
export(int) var points_2_stars = null
export(int) var points_3_stars = null
export(int) var time_to_complete = null

var player
var point_levels = [points_1_star, points_2_stars, points_3_stars]

var timer: Timer
var available_passengers

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
    timer.connect("timeout", self, "time_up")
    add_child(timer)

# ---------- BEFORE GAME STARTS ----------

func prepare_level(unlocked_passengers: Array):
    # make player instance and add to spawn pos
    player = load("res://player/Player.tscn").instance()
    $"PlayerPos".add_child(player)
    # make passenger instances and add to container node (AvailablePassengers)
    var passenger_instances = []
    for passenger_name in unlocked_passengers:
        var new_passenger = Passenger.new(passenger_name)
        passenger_instances.append(new_passenger)
        available_passengers.add_child(new_passenger)
    GuiManager.add_passenger_picker(passenger_instances)


func add_passenger_to_player(passenger_ref: Passenger):
    available_passengers.remove_child(passenger_ref)
    player.passengers.add_child(passenger_ref)


func remove_passenger_from_player(passenger_ref: Passenger, _seat_name: String):
    # TODO: fix this- super hacky, seat name is not needed here but since we only use one signal for gui and level, we do it this way
    player.passengers.remove_child(passenger_ref)
    available_passengers.add_child(passenger_ref)

# ----------  GAME STARTS ----------

func start_level(): # probably is going to be triggered by button in picker
    # free unused passengers that are still children of AvailablePassengers
    for passenger in available_passengers.get_children():
        passenger.queue_free()
    # connect selected passengers to player
    var passenger_refs = player.get_node("Car/PassengerManager").get_children()
    for passenger in passenger_refs:
        passenger.connect("passenger_raging", player, "_on_raging_passenger")
    # set up the gui
    GuiManager.load_game_hud(player, passenger_refs)
    # delay a bit and then start timer
    yield(get_tree().create_timer(1), "timeout") # TODO: clean wait until level starts - also disable driving car
    timer.start(time_to_complete)

# ---------- GAME OVER ----------

func player_crashed():
    pass


func time_up():
    GuiManager.clear_game_hud()
    level_passed()
    timer.stop()


func level_passed():
    emit_signal("level_completed", name, player.score) # TODO: this just test


func level_failed():
    pass


func restart_level():
    # TODO: maybe implement some reset_level() func that is called
    # TODO: then call prepare level -> but supply passenger picker with previously picked passengers
    pass

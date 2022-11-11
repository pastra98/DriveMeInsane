extends Node

export(int) var points_1_star = null
export(int) var points_2_stars = null
export(int) var points_3_stars = null
export(int) var time_to_complete = null

var player
var is_playing = false

const MAX_PASSENGERS = 4 # TODO: maybe later find better solution

func _ready():
    # do some checks here if the exports have been set by the scene
    for property in get_property_list():
        if property.usage == 8199 and get(property.name) == null:
            print("Property %s\nHas not been set in the inspector" % property.name); breakpoint
    # add container for passengers during level picking
    var available_passengers = Node2D.new()
    available_passengers.name = "AvailablePassengers"
    add_child(available_passengers)

# ---------- BEFORE GAME STARTS ----------

func prepare_level(unlocked_passengers: Array):
    # make player instance and add to spawn pos
    player = load("res://player/Player.tscn").instance()
    $PlayerPos.add_child(player)
    # make passenger instances and add to container node (AvailablePassengers)
    var passenger_instances = []
    for passenger_name in unlocked_passengers:
        var new_passenger = Passenger.new(passenger_name)
        passenger_instances.append(new_passenger)
        $AvailablePassengers.add_child(new_passenger)
    GuiManager.add_passenger_picker(passenger_instances)


func add_passenger_to_player(passenger_name: String):
    var passenger_to_move = $AvailablePassengers.get_node(passenger_name)
    $AvailablePassengers.remove_child(passenger_to_move)
    player.passengers.add_child(passenger_to_move)


func remove_passenger_from_player(passenger_name: String):
    var passenger_to_move = player.passengers.get_node(passenger_name)
    player.passengers.remove_child(passenger_to_move)
    $AvailablePassengers.add_child(passenger_to_move)

# ----------  GAME STARTS ----------

func start_level(): # probably is going to be triggered by button in picker
    # free unused passengers that are still children of AvailablePassengers
    for passenger in $AvailablePassengers.get_children():
        passenger.queue_free()
    # set up the gui
    GuiManager.add_player_status(player)
    for passenger in player.get_node("Car/PassengerManager").get_children():
        GuiManager.add_passenger_window(passenger)
    is_playing = true

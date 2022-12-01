extends CanvasLayer

onready var main = get_node("/root/Main")
onready var n_unlock_pass = main.unlocked_passengers.size()

# ---------- MAIN MENU ----------

func show_main_menu():
    clear_control_children()
    var bg_scene = load("res://environment/menu_background/MenuBackground.tscn").instance()
    main.add_child(bg_scene)
    var mm = load("res://gui/main_menu/MainMenu.tscn").instance()
    mm.get_node("LevelPicker").connect("new_level_picked", main, "load_level")
    add_child(mm)
    
# ---------- BEFORE LEVEL ----------

func show_passenger_picker(passenger_refs_arr: Array, lvl_info: Dictionary):
    clear_control_children()
    var before_level = load("res://gui/before_level/BeforeLevel.tscn").instance()
    add_child(before_level) # needs to be caled b4 adding passengers
    # pass passenger refs to Picker, TODO: make this more elegant - maybe add script to BeforeLevel scene root
    before_level.get_node("PassengerPicker").add_passenger_cards(passenger_refs_arr)
    before_level.get_node("PassengerPicker").connect("level_started", $"/root/Main/Level", "start_level")
    # pass level info to info scene
    before_level.get_node("LevelInfo").setup(lvl_info)
    # show picker tutorial
    if not main.is_tutorial_completed:
        before_level.get_node("PickerTutorial").popup_centered()

# ---------- UI WHILE DRIVING IN LEVEL ----------

func show_game_hud(player: Node2D, passenger_refs_arr: Array):
    # set's up the UI elements needed during gameplay
    clear_control_children()
    var hud = load("res://gui/game_hud/GameHUD.tscn").instance()
    add_child(hud) # TODO: consider delegating some stuff to the game HUD scene and add script there?
    # connect player to player status
    player.connect("new_health", $"GameHUD/PlayerStatus", "update_health")
    player.connect("new_score", $"GameHUD/PlayerStatus", "update_score")
    # add the passenger windows
    for passenger_ref in passenger_refs_arr:
        var new_passenger_window = load("res://gui/game_hud/passenger_window/PassengerWindow.tscn").instance()
        passenger_ref.connect("new_insanity", new_passenger_window, "update_insanity")
        passenger_ref.connect("new_picture", new_passenger_window, "update_picture")
        $"GameHUD/PassengerContainer".add_child(new_passenger_window)
        new_passenger_window.update_picture(passenger_ref.imgpath % "happy")
    # show tutorial if not completed
    if not main.is_tutorial_completed:
        hud.get_node("BeforeStartTutorial").popup_centered()
        get_tree().paused = true
        yield(hud.get_node("BeforeStartTutorial"), "popup_hide")
        get_tree().paused = false

# ---------- LEVEL OVER GUI  ----------

func show_level_over_gui(lvl_nr: int, stars: int, points: int):
    # first clear the in-game hud
    clear_control_children()
    # check if new unlocked passengers and show if this is the case
    if n_unlock_pass < main.unlocked_passengers.size():
        var new_ones = main.unlocked_passengers.slice(n_unlock_pass, -1)
        var unlocker = load("res://gui/game_over/passenger_unlocks/PassengerUnlocks.tscn").instance()
        unlocker.show_passengers(new_ones)
        add_child(unlocker)
        n_unlock_pass = main.unlocked_passengers.size()
        var close_button = unlocker.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/CloseWindowButton")
        yield(close_button, "button_down")
        unlocker.queue_free()
    # then show the game over screen
    var game_over_screen = load("res://gui/game_over/GameOver.tscn").instance()
    game_over_screen.setup(lvl_nr, stars, main.completed_lvls.has(lvl_nr), points)
    add_child(game_over_screen)

# ---------- UTILITIES ----------

func clear_control_children():
    for child in get_children():
        child.queue_free()

class_name Passenger
extends Node2D

signal new_insanity(amt, reason)
signal passenger_raging(pass_name, rage_pts)
signal new_picture(imgpath)

# base properties of passenger set by config - passenger name becomes node name
var insanity: int
var rage_points: int
var rage_cooldown_sec: int
var lore: String
# those are derived from the ressource_path
var soundpath
var imgpath: String

const INSANITY_LEVELS = [40, 80]
var raging = false
var rage_timer: Timer

var sensibilities = []

func _init(pass_name: String):
    name = pass_name
    load_passenger_config(pass_name)
    # set up rage timer
    rage_timer = Timer.new()
    rage_timer.name = "RageTimer"
    rage_timer.connect("timeout", self, "_on_rage_cooldown_finished")
    add_child(rage_timer)


func insanity_change(change_by, reason):
    if raging:
        return # do not register any insanity changes while ranging
    insanity = min(insanity + change_by, 100)
    emit_signal("new_insanity", insanity, reason)
    if insanity > INSANITY_LEVELS[1]:
        emit_signal("new_picture", imgpath % "angry")
        if insanity == 100:
            rage()
    elif insanity > INSANITY_LEVELS[0]:
        emit_signal("new_picture", imgpath % "unhappy")
    else:
        emit_signal("new_picture", imgpath % "happy")


func load_passenger_config(pass_name: String):
    var config = ConfigFile.new()
    # try to open the specified file, break execution if it doesn't exist
    var err = config.load("res://passengers/%s/%s.cfg" % [pass_name, pass_name])
    if err == OK:
        set_passenger_basics(config)
        set_passenger_sensibilities(config)
    else:
        push_error("Could not load config, error code: %d" % err); breakpoint


func set_passenger_basics(conf: ConfigFile):
    insanity = conf.get_value("Basics", "start_insanity")
    name = conf.get_value("Basics", "name")
    lore = conf.get_value("Basics", "lore")
    rage_points = conf.get_value("Basics", "rage_points")
    rage_cooldown_sec = conf.get_value("Basics", "rage_cooldown_sec")
    var ressource_path = conf.get_value("Basics", "ressource_path")
    imgpath = ressource_path + name + "_%s.png"
    soundpath = ressource_path + "_scream_%s.wav"


func set_passenger_sensibilities(conf: ConfigFile):
    for section in conf.get_sections():
        var new_sensibility
        match section:
            "TooCloseSensibility":
                new_sensibility = TooCloseSensibility.new(
                    conf.get_value(section, "too_fast"),
                    conf.get_value(section, "insanity_effect"),
                    conf.get_value(section, "coll_size_mult")
                    )
            "TooFastSensibility":
                new_sensibility = TooFastSensibility.new(
                    conf.get_value(section, "too_fast"),
                    conf.get_value(section, "insanity_effect")
                    )
            "TooSlowSensibility":
                new_sensibility = TooSlowSensibility.new(
                    conf.get_value(section, "too_slow"),
                    conf.get_value(section, "insanity_effect")
                    )
        if new_sensibility: # make sure the section that was read was a sensibility, not e.g. basics
            new_sensibility.connect("inc_insanity", self, "insanity_change")
            add_child(new_sensibility)
            sensibilities.append(new_sensibility)


func get_sensibilities_txt():
    var txt = ""
    for sensibility in sensibilities:
        txt = txt + sensibility.get_txt_description() + "\n"
    return txt


func rage():
    # TODO: play sound here
    # TODO: start timer
    # TODO: reset insanity after timer
    print("raging: %s + %s points" % [name, rage_points])
    emit_signal("passenger_raging", name, rage_points)
    rage_timer.start(rage_cooldown_sec)
    raging = true


func _on_rage_cooldown_finished():
    raging = false
    insanity_change(-100, "Ok, drive careful now")

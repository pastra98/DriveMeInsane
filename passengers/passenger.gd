class_name Passenger
extends Node2D

signal new_insanity(amt, reason)
signal new_picture(imgpath)

# base properties of passenger set by config - passenger name becomes node name
var insanity: int
var imgpath: String
var lore: String

const INSANITY_LEVELS = [40, 80]

func _init(pass_name: String):
    name = pass_name
    load_passenger_config(pass_name)


func insanity_change(change_by, reason):
    insanity = min(insanity + change_by, 100)
    emit_signal("new_insanity", insanity, reason)
    if insanity > INSANITY_LEVELS[1]:
        emit_signal("new_picture", imgpath % "angry")
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
    imgpath = conf.get_value("Basics", "imgpath")
    lore = conf.get_value("Basics", "lore")


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


func get_sensibilities_txt():
    var txt = ""
    for sensibility in get_children():
        txt = txt + sensibility.get_txt_description() + "\n"
    return txt

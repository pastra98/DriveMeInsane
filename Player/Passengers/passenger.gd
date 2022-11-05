class_name Passenger
extends Node2D

var sensibilities: Array = []

var insanity: int
var passenger_name: String
var image
var start_insanity: int

func _init(pass_name: String):
    name = pass_name
    load_passenger_config(pass_name)


func insanity_change(change_by):
    insanity += change_by
    print(insanity)


func load_passenger_config(pass_name: String):
    var config = ConfigFile.new()
    # try to open the specified file, break execution if it doesn't exist
    var err = config.load("res://Player/Passengers/%s.cfg" % pass_name)
    if err == OK:
        set_passenger_basics(config)
        set_passenger_sensibilities(config)
    else:
        push_error("Could not load config, error code: %d" % err); breakpoint


func set_passenger_basics(conf: ConfigFile):
    insanity = conf.get_value("Basics", "start_insanity")
    passenger_name = conf.get_value("Basics", "name")
    image = conf.get_value("Basics", "image")
    start_insanity = conf.get_value("Basics", "start_insanity")


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
            sensibilities.append(new_sensibility)
            new_sensibility.connect("inc_insanity", self, "insanity_change")
            add_child(new_sensibility)

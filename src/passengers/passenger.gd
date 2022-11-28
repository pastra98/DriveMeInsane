class_name Passenger
extends Node2D

signal new_insanity(amt, reason)
signal passenger_raging(pass_name, rage_pts)
signal new_picture(imgpath)

# base properties of passenger set by config - passenger name becomes node name
var insanity: float
var rage_points: int
var rage_cooldown_sec: int
var lore: String
# those are derived from the ressource_path
var soundpath: String
var imgpath: String

const INSANITY_LEVELS = [25, 50, 75, 100]
var insanity_lvl = 0

var raging = false
var rage_timer: Timer
var sound_player: AudioStreamPlayer

var sensibilities = []

func _init(pass_name: String):
    name = pass_name
    load_passenger_config(pass_name)
    # set up rage timer
    rage_timer = Timer.new()
    rage_timer.name = "RageTimer"
    rage_timer.connect("timeout", self, "_on_rage_cooldown_finished")
    add_child(rage_timer)
    # set up audio player
    sound_player = AudioStreamPlayer.new()
    sound_player.name = "SoundPlayer"
    sound_player.volume_db = -10
    add_child(sound_player)


func insanity_change(change_by, reason, is_broadcast):
    if raging:
        return # do not register any insanity changes while raging
    # if it is a broadcast, it should only affect other passengers
    if is_broadcast:
        get_parent().change_everyones_insanity(self, change_by, reason)
        return
    insanity = clamp(insanity + change_by, 0.0, 100.0)
    emit_signal("new_insanity", insanity, reason)
    #  figure out insanity lvl
    var i = 0
    for lvl in INSANITY_LEVELS:
        if insanity < lvl:
            break
        i += 1
    # check if new insanity lvl is higher than prev one
    if i > insanity_lvl:
        insanity_lvl = i
        if change_by > 0: # only scream when insanity increases
            scream(insanity_lvl)
        if insanity_lvl == 4:
            rage()
            insanity_lvl = -1
            return
        # don't change image after max inanity
        emit_signal("new_picture", imgpath % [["happy", "happy", "unhappy", "angry"][insanity_lvl]])


func load_passenger_config(pass_name: String):
    var config = ConfigFile.new()
    # try to open the specified file, break execution if it doesn't exist
    var err = config.load("res://passengers/ressources/%s/%s.cfg" % [pass_name, pass_name])
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
    soundpath = ressource_path + name + "_scream_%s.wav"


func set_passenger_sensibilities(conf: ConfigFile):
    for section in conf.get_sections():
        var new_sensibility
        match section:
            "TooCloseSensibility":
                new_sensibility = TooCloseSensibility.new(
                    conf.get_value(section, "too_fast"),
                    conf.get_value(section, "coll_size_mult"),
                    conf.get_value(section, "insanity_effect"),
                    conf.get_value(section, "cooldown")
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
            "AutomaticEffect":
                new_sensibility = AutomaticEffect.new(
                    conf.get_value(section, "message"),
                    conf.get_value(section, "is_broadcasting"),
                    conf.get_value(section, "insanity_effect"),
                    conf.get_value(section, "cooldown")
                    )
            "RelaxationFart":
                new_sensibility = RelaxationFart.new(
                    conf.get_value(section, "insanity_effect"),
                    conf.get_value(section, "cooldown")
                    )
            "DriftHater":
                new_sensibility = DriftHater.new(
                    conf.get_value(section, "insanity_effect")
                    )
            "AllGasNoBrakes":
                new_sensibility = AllGasNoBrakes.new(
                    conf.get_value(section, "insanity_required")
                    )
                connect("new_insanity", new_sensibility, "_on_new_insanity")
            "InsanityScream":
                new_sensibility = InsanityScream.new(
                    conf.get_value(section, "insanity_effect")
                    )
                connect("passenger_raging", new_sensibility, "_on_passenger_raging") # connect signal to sensibility
        if new_sensibility: # make sure the section that was read was a sensibility, not e.g. basics
            # add cooldown timer as child to every sensibility
            var cooldown_timer = Timer.new()
            cooldown_timer.name = new_sensibility.name + "Timer"
            cooldown_timer.connect("timeout", new_sensibility, "cooldown_over")
            new_sensibility.add_child(cooldown_timer)
            new_sensibility.connect("change_insanity", self, "insanity_change")
            add_child(new_sensibility)
            sensibilities.append(new_sensibility)


func get_sensibilities_txt():
    var txt = "+%s rage points\n\n" % rage_points
    for sensibility in sensibilities:
        txt = txt + "- " + sensibility.get_txt_description() + "\n"
    return txt


func rage():
    emit_signal("passenger_raging", name, rage_points)
    rage_timer.start(rage_cooldown_sec)
    raging = true


func scream(rage_lvl: int):
    sound_player.stream = load(soundpath % [rage_lvl])
    sound_player.play()


func _on_rage_cooldown_finished():
    rage_timer.stop()
    raging = false
    insanity_change(-100, "Ok, drive careful now", false)

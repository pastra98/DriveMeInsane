extends MarginContainer

var timer: Timer
# var text_timeout

onready var bar = $VBoxContainer/InsanityBar
onready var label = $VBoxContainer/CurrentEffect
onready var img = $VBoxContainer/PassengerPic

func _ready():
    timer = Timer.new()

func update_insanity(new_value, reason):
    bar.value = new_value
    var col = "red" if new_value > 0 else "red"
    label.bbcode_text = "[wave amp=51 freq=10][color=%s]%s" % [col, reason]
    if new_value > 0:
        $"AnimationPlayer".play("go_red_anim")
    else:
        $"AnimationPlayer".play("go_blue_anim")


func clear_text():
    label.bbcode_text = ""


func update_picture(imgpath):
    img.texture = load(imgpath)

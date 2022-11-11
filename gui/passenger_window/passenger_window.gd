extends MarginContainer

var timer: Timer
# var text_timeout

onready var bar = $NinePatchRect/InsanityBar
onready var label = $NinePatchRect/CurrentEffect
onready var img = $NinePatchRect/PassengerPic

func _ready():
    timer = Timer.new()

func update_insanity(new_value, reason):
    bar.value = new_value
    # label.bbcode_text = "[b]%s[/b]" % reason
    label.bbcode_text = "[b][color=red]%s[/color][/b]" % reason


func clear_text():
    label.bbcode_text = ""


func update_picture(imgpath):
    img.texture = load(imgpath)

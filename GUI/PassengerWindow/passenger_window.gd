class_name PassengerWindow
extends MarginContainer

var insanity: int
var timer: Timer
# var text_timeout

onready var bar = $NinePatchRect/Gauge
onready var label = $NinePatchRect/RichTextLabel
onready var img = $NinePatchRect/TextureRect2

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

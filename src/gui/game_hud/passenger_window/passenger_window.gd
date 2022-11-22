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
    # label.bbcode_text = "[b]%s[/b]" % reason
    label.bbcode_text = "[b][color=red]%s[/color][/b]" % reason


func clear_text():
    label.bbcode_text = ""


func update_picture(imgpath):
    img.texture = load(imgpath)

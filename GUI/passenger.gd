extends MarginContainer

var picture: String
var insanity: int
onready var number_label = $Bars/LifeBar/Count/Background/Number
onready var bar = $Bars/LifeBar/TextureProgress

func _ready():
    pass # Replace with function body.

func update_insanity(new_value):
    number_label.text = str(new_value)
    bar.value = new_value
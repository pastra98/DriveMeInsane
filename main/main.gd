extends Node2D

var player
onready var bg_scene = load("res://environment/menu_background/BackgroundLevel.tscn").instance()

func _ready():
    add_child(bg_scene)
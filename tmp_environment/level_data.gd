extends Node

export(int) var required_points = null

func _ready():
    # do some checks here if the exports have been set by the scene
    if required_points:
        print(required_points)
    else:
        print("set points!!!")

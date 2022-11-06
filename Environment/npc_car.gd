extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 200
var motion = Vector2()
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta):
    motion.y += speed * direction 
    motion = move_and_slide(motion)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

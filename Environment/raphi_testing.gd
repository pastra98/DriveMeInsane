extends Area2D

var time: int = 0

func _ready():
    var new_car = load("res://Npc/NpcCar.tscn").instance()
    new_car.global_position = $NpcSpawner.global_position
    add_child(new_car)
    

#func _on_RaphiMap_body_exited(body:Node):
#	body.rotate_and_move()

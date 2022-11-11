extends VBoxContainer

onready var button_container = $PassengerPic/VBoxContainer


func _ready():
    pass


func _on_PassengerPic_mouse_entered():
    button_container.show()


func _on_PassengerPic_mouse_exited():
    if not Rect2(Vector2(), rect_size).has_point(get_local_mouse_position()):
        button_container.hide()
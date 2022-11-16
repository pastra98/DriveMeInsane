extends RigidBody2D

var maxSpeed = 900
var acceleration = 5
var steering = 5

func _integrate_forces(state):
    """
    """
    var fwd = 0 + int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
    var lr = 0 + int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
    # 
    var speed =  fwd * -state.transform.y * acceleration
    state.add_central_force(speed)
    # 
    var direction = state.linear_velocity.dot(state.transform.y)
    # Steer 
    if direction >= 0:
        state.add_torque(lr * steering * (state.linear_velocity.length() / maxSpeed))
    else:
        state.add_torque(lr * -steering * (state.linear_velocity.length() / maxSpeed))
    # 
    var driftForce = state.linear_velocity.dot(state.transform.x) * 2
    var relativeForce = Vector2.RIGHT * driftForce
    if state.linear_velocity.length() > maxSpeed:
        state.linear_velocity = state.linear_velocity.normalized() * maxSpeed
    state.add_central_force(state.transform.basis_xform(relativeForce))

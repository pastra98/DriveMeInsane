extends RigidBody2D

# Driving Properties
const ACCELERATION = 5
const MAX_FORWARD_VELOCITY = 900
const DRAG_COEFFICIENT = 0.999 # Recommended: 0.99 - Affects how fast you slow down
const STEERING_TORQUE = 10 # Affects turning speed
const STEERING_DAMP = 8 # 7 - Affects how fast the torque slows down

# Drifting & Tire Friction
var can_drift = true
var _drift_factor = WHEEL_GRIP_STICKY # Determines how much (or little) your vehicle drifts
const WHEEL_GRIP_STICKY = 0.85 # Default drift coef (will stick to road, most of the time)
const WHEEL_GRIP_SLIPPERY = 0.99 # Affects how much you "slide"
const DRIFT_EXTREMUM = 250 # Right velocity higher than this will cause you to slide
const DRIFT_ASYMPTOTE = 20 # During a slide you need to reduce right velocity to this to gain control

# Vehicle velocity and angular velocity. Override rigidbody velocity in physics process
var _velocity = Vector2()
var _angular_velocity = 0


func _ready():
    """
    """
    angular_damp = STEERING_DAMP


func _integrate_forces(state):
    """
    """
    # use our own drag
    _velocity *= DRAG_COEFFICIENT
    if can_drift:
        # If we are sticking to the road and our right velocity is high enough
        if _drift_factor == WHEEL_GRIP_STICKY and get_right_velocity().length() > DRIFT_EXTREMUM:
            _drift_factor = WHEEL_GRIP_SLIPPERY
        # If we are sliding on the road
        elif get_right_velocity().length() < DRIFT_ASYMPTOTE:
            _drift_factor = WHEEL_GRIP_STICKY
    # Add drift to velocity
    _velocity = get_up_velocity() + (get_right_velocity() * _drift_factor)
    # Accelerate
    if Input.is_action_pressed("ui_up"):
        _velocity += -transform.y * ACCELERATION
    # Break / Reverse
    elif Input.is_action_pressed("ui_down"):
        _velocity -= -transform.y * ACCELERATION
    # Prevent exceeding max velocity
    var max_speed = (Vector2(0, -1) * MAX_FORWARD_VELOCITY).rotated(get_rotation())
    var x = clamp(_velocity.x, -abs(max_speed.x), abs(max_speed.x))
    var y = clamp(_velocity.y, -abs(max_speed.y), abs(max_speed.y))
    _velocity = Vector2(x, y)
    # Torque depends that the vehicle is moving
    var torque = lerp(0, STEERING_TORQUE, _velocity.length() / MAX_FORWARD_VELOCITY)
    # Steer Right
    if Input.is_action_pressed("ui_right"):
        state.angular_velocity = torque
    # Steer Left
    elif Input.is_action_pressed("ui_left"):
        state.angular_velocity = -torque
    # Apply the force
    state.linear_velocity = _velocity
    

func get_up_velocity() -> Vector2:
    # Returns the vehicle's forward velocity
    return -transform.y * _velocity.dot(-transform.y)


func get_right_velocity() -> Vector2:
    # Returns the vehicle's sidewards velocity
    return -transform.x * _velocity.dot(-transform.x)


func crash(body) -> void:
    """
    """
    $Explosion.show() # old code from prev project
    $Explosion.play()
    $Sprite.hide()


func _on_Explosion_animation_finished() -> void:
    $Explosion.stop(); $Explosion.hide()

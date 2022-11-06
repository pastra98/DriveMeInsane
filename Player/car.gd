extends RigidBody2D

# Driving Properties
var acceleration = 15
var max_forward_velocity = 1000
var drag_coefficient = 0.99 # Recommended: 0.99 - Affects how fast you slow down
var steering_torque = 15 # Affects turning speed
var steering_damp = 8 # 7 - Affects how fast the torque slows down

# Drifting & Tire Friction
var can_drift = true
var wheel_grip_sticky = 0.85 # Default drift coef (will stick to road, most of the time)
var wheel_grip_slippery = 0.99 # Affects how much you "slide"
var drift_extremum = 250 # Right velocity higher than this will cause you to slide
var drift_asymptote = 20 # During a slide you need to reduce right velocity to this to gain control
var _drift_factor = wheel_grip_sticky # Determines how much (or little) your vehicle drifts

# Vehicle velocity and angular velocity. Override rigidbody velocity in physics process
var _velocity = Vector2()
var _angular_velocity = 0

# vehicle forward speed
var speed: int

# gets emitted when the car crashes
signal player_crashed(name)

func _ready():
    """Connect the car to the bounds of the track, receive a signal when (any) car
    collides with the bounds. Generate raycasts to measure the distance to the bounds.
    """
    # Added steering_damp since it may not be obvious at first glance that
    # you can simply change angular_damp to get the same effect
    set_angular_damp(steering_damp)
    set_contact_monitor(true)
    set_max_contacts_reported(3)
    $PassengerManager


func _physics_process(delta):
    """This script overrides the behavior of a rigidbody (Not my idea, but it works).
    """
    # make sure that sensory information gets updated every 0.2 seconds
    # Update the forward speed
    speed = -get_up_velocity().dot(transform.y)
    # use our own drag
    _velocity *= drag_coefficient
    if can_drift:
        # If we are sticking to the road and our right velocity is high enough
        if _drift_factor == wheel_grip_sticky and get_right_velocity().length() > drift_extremum:
            _drift_factor = wheel_grip_slippery
        # If we are sliding on the road
        elif get_right_velocity().length() < drift_asymptote:
            _drift_factor = wheel_grip_sticky
    # Add drift to velocity
    _velocity = get_up_velocity() + (get_right_velocity() * _drift_factor)
    # Accelerate
    if Input.is_action_pressed("ui_up"):
        _velocity += -transform.y * acceleration
    # Break / Reverse
    elif Input.is_action_pressed("ui_down"):
        _velocity -= -transform.y * acceleration
    # Prevent exceeding max velocity
    var max_speed = (Vector2(0, -1) * max_forward_velocity).rotated(get_rotation())
    var x = clamp(_velocity.x, -abs(max_speed.x), abs(max_speed.x))
    var y = clamp(_velocity.y, -abs(max_speed.y), abs(max_speed.y))
    _velocity = Vector2(x, y)
    # Torque depends that the vehicle is moving
    var torque = lerp(0, steering_torque, _velocity.length() / max_forward_velocity)
    # Steer Right
    if Input.is_action_pressed("ui_right"):
        set_angular_velocity(torque * sign(speed))
    # Steer Left
    elif Input.is_action_pressed("ui_left"):
        set_angular_velocity(-torque * sign(speed))
    # Apply the force
    set_linear_velocity(_velocity)


func get_up_velocity() -> Vector2:
    # Returns the vehicle's forward velocity
    return -transform.y * _velocity.dot(-transform.y)


func get_right_velocity() -> Vector2:
    # Returns the vehicle's sidewards velocity
    return -transform.x * _velocity.dot(-transform.x)


func crash(body) -> void:
    """Check if the body that collided with the bounds is self. If so, show an explosion
    and emit the death signal, causing the fitness to be evaluated by the ga node.
    JUSTIFICATION: Using a signal from the track and then checking every car if it was the
    one that crashed is apparently a lot more efficient than providing every car with
    it's own collider.
    """
    if body == self:
        $Explosion.show(); $Explosion.play()
        $Sprite.hide()
        emit_signal("player_crashed", "The Player")


func _on_Explosion_animation_finished() -> void:
    $Explosion.stop(); $Explosion.hide()

#func handle_collision():

func _on_Car_body_entered(body:Node):
	$SoundExplosion.play() 

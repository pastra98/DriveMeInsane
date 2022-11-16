extends RigidBody2D

# Driving Properties
const ACCELERATION = 10
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
var _angular_velocity = 0
var collision_force : Vector2 = Vector2.ZERO

var prev_lv : Vector2 = Vector2.ZERO

func _ready():
    """
    """
    angular_damp = STEERING_DAMP


func _integrate_forces(state):
    """
    """
    # Accelerate
    if Input.is_action_pressed("ui_up"):
        state.add_central_force(-transform.y * ACCELERATION)
    # Break / Reverse
    elif Input.is_action_pressed("ui_down"):
        state.add_central_force(transform.y * ACCELERATION)
    # Prevent exceeding max velocity
    var max_speed = (Vector2(0, -1) * MAX_FORWARD_VELOCITY).rotated(get_rotation())
    var x = clamp(state.linear_velocity.x, -abs(max_speed.x), abs(max_speed.x))
    var y = clamp(state.linear_velocity.y, -abs(max_speed.y), abs(max_speed.y))
    state.linear_velocity = Vector2(x, y)
    # Torque depends that the vehicle is moving
    var torque = lerp(0, STEERING_TORQUE, state.linear_velocity.length() / MAX_FORWARD_VELOCITY)
    # Steer Right
    if Input.is_action_pressed("ui_right"):
        state.angular_velocity = torque
    # Steer Left
    elif Input.is_action_pressed("ui_left"):
        state.angular_velocity = -torque
    # engine sounds
    # TODO: shifting, braking, ignition maybe...
    $"Sounds/Engine".pitch_scale = range_lerp(state.linear_velocity.length(), 0, MAX_FORWARD_VELOCITY, 0.5, 3)
    $"Sounds/Engine".volume_db = min(-60 + state.linear_velocity.length()/2, -10)

    collision_force = Vector2.ZERO
    if state.get_contact_count() > 0:
        var dv : Vector2 = state.linear_velocity - prev_lv
        collision_force = dv / (state.inverse_mass * state.step)
        print(collision_force.length())

extends RigidBody2D

signal damage_taken(amt)

# Driving Properties
const MAX_ACCELERATION = 5
const MAX_FORWARD_VELOCITY = 900
const DRAG_COEFFICIENT = 0.999 # Recommended: 0.99 - Affects how fast you slow down
const BRAKE_POWER = 0.95 # Recommended: 0.99 - Affects how fast you slow down
const STEERING_TORQUE = 5 # Affects turning speed
const STEERING_DAMP = 8 # 7 - Affects how fast the torque slows down

var acceleration = 0
var all_gas_no_brakes = false

# Drifting & Tire Friction
var _drift_factor = WHEEL_GRIP_STICKY # Determines how much (or little) your vehicle drifts
const WHEEL_GRIP_STICKY = 0.85 # Default drift coef (will stick to road, most of the time)
const WHEEL_GRIP_SLIPPERY = 0.99 # Affects how much you "slide"
const DRIFT_EXTREMUM = 250 # Right velocity higher than this will cause you to slide
const DRIFT_ASYMPTOTE = 20 # During a slide you need to reduce right velocity to this to gain control

# Vehicle velocity and angular velocity. Override rigidbody velocity in physics process
var _lv_override = Vector2()
var _angular_velocity = 0
var _is_braking = false

var prev_lv : Vector2 = Vector2.ZERO
var t_vel_update: float = 0.0

var sound_rng = RandomNumberGenerator.new()

func _ready():
    """
    """
    sound_rng.randomize()
    angular_damp = STEERING_DAMP


func _integrate_forces(state):
    """
    """
    # update velocity every 0.2 timesteps
    t_vel_update += state.step
    if t_vel_update > 0.2:
        prev_lv = state.linear_velocity
        t_vel_update = 0
    # if there are collsions, the coll force is dv magnitude / 100
    if state.get_contact_count() > 0:
        var col_force = (state.linear_velocity - prev_lv).length() / 100
        state.apply_impulse(state.get_contact_local_position(0), state.get_contact_local_normal(0)*col_force)
        state.angular_velocity = clamp(state.angular_velocity, -TAU, TAU)
        _lv_override = state.linear_velocity
        play_crash_sound(col_force)
        emit_signal("damage_taken", col_force)
    # handbrake velocity override
    _is_braking = Input.is_action_pressed("ui_select") and not all_gas_no_brakes
    if _is_braking:
        _lv_override *= BRAKE_POWER
    else:
        _lv_override *= DRAG_COEFFICIENT
    # If we are sticking to the road and our right velocity is high enough
    # TODO: play some drifting sounds
    var r_vel = get_right_velocity()
    if (_drift_factor == WHEEL_GRIP_STICKY and r_vel.length() > DRIFT_EXTREMUM) or _is_braking:
        _drift_factor = WHEEL_GRIP_SLIPPERY
        $"Sounds/Tires".volume_db = min(-80 + _lv_override.length()/2, -40)
        $"Sounds/Tires".stream_paused = false
    # If we are sliding on the road
    elif r_vel.length() < DRIFT_ASYMPTOTE:
        _drift_factor = WHEEL_GRIP_STICKY
        $"Sounds/Tires".stream_paused = true
    # Add drift to velocity
    _lv_override = get_up_velocity() + (r_vel * _drift_factor)
    # Accelerate
    if Input.is_action_pressed("ui_up") or all_gas_no_brakes:
        _lv_override += -transform.y * acceleration
    # Break / Reverse
    elif Input.is_action_pressed("ui_down") and not all_gas_no_brakes:
        _lv_override -= -transform.y * acceleration
    # Prevent exceeding max velocity
    var max_speed = (Vector2(0, -1) * MAX_FORWARD_VELOCITY).rotated(get_rotation())
    var x = clamp(_lv_override.x, -abs(max_speed.x), abs(max_speed.x))
    var y = clamp(_lv_override.y, -abs(max_speed.y), abs(max_speed.y))
    _lv_override = Vector2(x, y)
    # Torque depends that the vehicle is moving
    var torque = lerp(0, STEERING_TORQUE, _lv_override.length() / MAX_FORWARD_VELOCITY)
    # Steer Right
    if Input.is_action_pressed("ui_right"):
        state.angular_velocity = torque
    # Steer Left
    elif Input.is_action_pressed("ui_left"):
        state.angular_velocity = -torque
    # Apply the force
    state.linear_velocity = _lv_override
    # engine sounds
    # TODO: shifting, ignition maybe...
    $"Sounds/Engine".pitch_scale = range_lerp(_lv_override.length(), 0, MAX_FORWARD_VELOCITY, 0.5, 3)
    $"Sounds/Engine".volume_db = min(-80 + _lv_override.length()/2, -50)
    

func get_up_velocity() -> Vector2:
    # Returns the vehicle's forward velocity
    return -transform.y * _lv_override.dot(-transform.y)


func get_right_velocity() -> Vector2:
    # Returns the vehicle's sidewards velocity
    return -transform.x * _lv_override.dot(-transform.x)


func play_crash_sound(col_force: float):
    for as_player in $"Sounds/Crashes".get_children():
        if sound_rng.randf() < 0.3 and not as_player.playing:
            as_player.volume_db = range_lerp(col_force, 0, 7, -80, -40)
            as_player.play()
            break


func disable():
    acceleration = 0


func enable():
    acceleration = MAX_ACCELERATION

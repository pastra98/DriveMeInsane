extends RigidBody2D

var destroyed = false
var rng = RandomNumberGenerator.new()
export (Array, Texture) var fragment_pics

func destroy():
    if not destroyed:
        destroyed = true
        $"CPUParticles2D".emitting = true
        $"Timer".start(3)
        for frag_pic in fragment_pics:
            var rb = RigidBody2D.new()
            rb.collision_layer = 0
            var spr = Sprite.new()
            spr.texture = frag_pic
            rb.add_child(spr)
            var col = CollisionShape2D.new()
            col.shape = CircleShape2D.new()
            rb.add_child(col)
            $"Fragments".add_child(rb)
        yield(get_tree().create_timer(0.01), "timeout")
        for rb in $"Fragments".get_children():
            rb.linear_velocity = linear_velocity + Vector2(rng.randf_range(-10,10), rng.randf_range(-10,10))
            rb.angular_velocity = angular_velocity
            rb.linear_damp = 0.99
            rb.angular_damp = 0.99
        $"Complete".hide()


func _on_Timer_timeout():
    queue_free()

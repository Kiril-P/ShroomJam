# rock.gd — NO SIGNALS NEEDED
extends RigidBody2D

func _ready():
	gravity_scale = 0.1
	linear_velocity.x = randf_range(-1, 1)
	linear_velocity.y = randf_range(1, 1)

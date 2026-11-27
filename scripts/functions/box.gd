#extends RigidBody2D
#@onready var ray_cast_r: RayCast2D = $RayCastR
#@onready var ray_cast_l: RayCast2D = $RayCastL
#
#
#func _process(delta: float) -> void:
	#if ray_cast_l.is_colliding() or ray_cast_r.is_colliding():
		#linear_velocity = Vector2.ZERO
		#angular_velocity = 0

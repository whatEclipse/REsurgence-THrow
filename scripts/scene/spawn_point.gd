extends RigidBody2D

const SETTLE_SPEED := 8.0   
const SETTLE_TIME := 0.3    

var _slow_time := 0.0


func _ready() -> void:
	lock_rotation = true


func _physics_process(delta: float) -> void:
	if freeze:
		return
	if linear_velocity.length() < SETTLE_SPEED:
		_slow_time += delta
		if _slow_time >= SETTLE_TIME:
			freeze = true
	else:
		_slow_time = 0.0

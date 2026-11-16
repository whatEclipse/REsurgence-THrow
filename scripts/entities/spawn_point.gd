extends RigidBody2D

const SETTLE_SPEED := 8.0   # below this speed it counts as stopped
const SETTLE_TIME := 0.3    # seconds it must stay that slow

var _slow_time := 0.0

@onready var kill_detector: Area2D = $KillDetector

func _ready() -> void:
	lock_rotation = true
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(func(body: Node) -> void: print("touched: ", body.name))

const FALL_LIMIT := 500.0  # y position below the lowest part of your level

func _physics_process(delta: float) -> void:
	if global_position.y > FALL_LIMIT:
		queue_free()
		return
	if freeze:
		return
	if linear_velocity.length() < SETTLE_SPEED:
		_slow_time += delta
		if _slow_time >= SETTLE_TIME:
			freeze = true
	else:
		_slow_time = 0.0

func _on_kill_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("kill_zone"):
		queue_free()

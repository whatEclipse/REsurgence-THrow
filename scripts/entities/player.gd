extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -170.0
var isDying = false

var start_position: Vector2

func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:

	if isDying == false:
		if not is_on_floor():
			velocity += get_gravity()* delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
			
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("Idle")
			else:
				animated_sprite.play("Walking")
		elif velocity.y < 0:
			animated_sprite.play("Jump")
		else:
			animated_sprite.play("Fall")
			
		if direction == 1:
			animated_sprite.flip_h = true;
		if direction == -1:
			animated_sprite.flip_h = false;

		move_and_slide()
	
func die():
	SFXManager.play_death()
	if isDying:
		return
	isDying = true
	animated_sprite.play("Death")
	await animated_sprite.animation_finished
	velocity = Vector2.ZERO
	if not SpawnManager.respawn_player():
		global_position = start_position # no flag placed yet
	isDying = false
	
func jumpOn():
	if isDying == false:
		velocity.y -= 300

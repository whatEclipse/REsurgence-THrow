extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -150.0
var isDying = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if isDying == false:
		if not is_on_floor():
			velocity += get_gravity()* delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY




		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
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
	isDying = true
	animated_sprite.play("Death")
	await animated_sprite.animation_finished
	isDying = false
	

extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var AttackCooldown = 0.6;
var CharacterDirection = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("Attack") and AttackCooldown <= 0:
		pass
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Backward", "Forward")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# this doesnt currently work but im too lazy to fix it 
	if direction == 1 and CharacterDirection == -1:
		get_parent().flip_h = true
		CharacterDirection = -1
	
	if direction == -1 and CharacterDirection == 1:
		get_parent().flip_h = false
		CharacterDirection = 1
		
	move_and_slide()

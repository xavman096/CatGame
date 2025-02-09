extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var AttackCooldown = 2
var CharacterDirection = 1
var CanAttack = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Backward", "Forward")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)	
	
	if direction == 1 and CharacterDirection == -1:
		self.get_node("Player").flip_h = false
		self.get_node("CollisionShape2D").position.x = 0
		CharacterDirection = 1
	
	if direction == -1 and CharacterDirection == 1:
		self.get_node("Player").flip_h = true
		self.get_node("CollisionShape2D").position.x = -42.25
		CharacterDirection = -1
		
	if Input.is_action_just_pressed("Attack") and AttackCooldown <= 0:
		print("Attacked")
		# For animation to play when attacking but no hitting anything
		
		
	AttackCooldown = AttackCooldown - 0.2
	move_and_slide()

	if Input.is_action_just_pressed("Attack") and AttackCooldown <= 0 and CanAttack == true:
		AttackCooldown = 2
		get_parent().get_node("Enemy").queue_free()
		print("Destroyed Item")

func _on_area_2d_area_entered(_area):
	CanAttack = true
	print("Player entered enemy")

func _on_area_2d_area_exited(_area):
	CanAttack = false
	print("Player exited enemy")

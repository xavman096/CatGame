extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -400.0
var AttackCooldown = 30
var CharacterDirection = 1
var CanAttack = false

var BoundryCollision
var BoundryPosition

var PlayerAttacked = false
var AttackedObject = ""

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
		
	if Input.is_action_just_pressed("Attack") && CanAttack == true && AttackCooldown <= 0:
		PlayerAttacked = true
		AttackCooldown = 30
		
	AttackCooldown = AttackCooldown - 1
	move_and_slide()

func _on_prefab_boundry_1_body_entered(body):
	if body.name == "Player":
		BoundryPosition = body.position
		BoundryCollision = true
		print(BoundryPosition)
		
func _on_fruit_bowl_area_body_entered(body):
		if body.name == "Player":
			AttackedObject = "FruitBowl"
			CanAttack = true
			print("Fruit Entered")

func _on_fruit_bowl_area_body_exited(body):
		if body.name == "Player":
			CanAttack = false
			print("Fruit Exitied")

func _on_apple_area_body_entered(body):
	if body.name == "Player":
		CanAttack = true
		AttackedObject = "Apple"
		print("Apple entered")
		
func _on_apple_area_body_exited(body):
		if body.name == "Player":
			CanAttack = false
			print("Apple Exited")
		
func _on_banana_area_body_entered(body):
		if body.name == "Player":
			CanAttack = true
			AttackedObject = "Banana"
			print("Banana entered")
			
func _on_banana_area_body_exited(body):
		if body.name == "Player":
			CanAttack = false
			print("Banana Exited")

func _on_pear_area_body_entered(body):
		if body.name == "Player":
			CanAttack = true
			AttackedObject = "Pear"
			print("Pear entered")

func _on_pear_area_body_exited(body):
		if body.name == "Player":
			CanAttack = true
			print("Pear Exited")
		









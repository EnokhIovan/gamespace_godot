extends CharacterBody2D

# PLAYER VAR
const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# JETPACK VAR
var jetpack_max_force = -100
var jetpack_max_fuel = 6.0
var height_max_quota = 5000
var jetpack_force = jetpack_max_force 
var jetpack_fuel = jetpack_max_fuel
var height_quota = height_max_quota

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle Jetpack 
	if Input.is_action_pressed("ui_accept"):
		print("Spasi dipencet!")
		
		if jetpack_fuel > 0:
			if height_quota > 0:
				height_quota += jetpack_force
				velocity.y = jetpack_force
				#print("Height quota: ", height_quota, " (On Pressed)")
			else:
				velocity.y = 0
				print("Maks ketinggian tercapai!")
			jetpack_fuel -= delta
			print("Fuel: ", jetpack_fuel)
		
		if jetpack_fuel < 0:
			print("Fuel habis!")
	else:
		if(height_quota < height_max_quota):
			height_quota -= jetpack_force
			#print("Height quota: ", height_quota, " (On Release)")
	
	 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

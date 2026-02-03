extends CharacterBody3D

var SPEED_DEFAULT
var SPEED = 3.0
var SPRINT_SPEED = 5.0
var CROUCH_SPEED = 1.5
var stamina
var stamina_step = 0.3
var stamina_cooldown = false
var exhausted = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var crouching = false
var crouch_height = 0.5
var stand_height = 2.0		# based on collisionshape height

var distance = 0
var footstep_distance = 1.5

var inventory
var toggle_inventory = false

func _ready() -> void:
	$head/AnimationPlayer.play("head_bob")
	SPEED_DEFAULT = SPEED;
	stamina = get_node("/root/" + get_tree().current_scene.name + "/UI/stamina")
	inventory = get_node("/root/" + get_tree().current_scene.name + "/UI/inventory")

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("interact"):
		$interaction_click.play()
	
	# open/close inventory
	if Input.is_action_just_pressed("inventory") and !$head/RayCast3D.talking:
		toggle_inventory = !toggle_inventory
		inventory.visible = toggle_inventory
		if toggle_inventory:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# deplete stamina
	if SPEED == SPRINT_SPEED and velocity.length() > 0:
		stamina.value = stamina.value - stamina_step * delta
		if stamina.value == stamina.min_value:
			SPEED = SPEED_DEFAULT
			$head/AnimationPlayer.speed_scale = 2.0
			# prevents glitching at 0 stamina
			stamina_cooldown = true
			# pauses stamina recovery for 1 second
			exhausted = true
			await get_tree().create_timer(1.0).timeout
			exhausted = false
	# restore stamina
	if (SPEED != SPRINT_SPEED or velocity.length() == 0) and !exhausted:
		if stamina.value < stamina.max_value:
			stamina.value = stamina.value + stamina_step/1.5 * delta
		if stamina.value == stamina.max_value:
			stamina.visible = false

# movement
func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y -= gravity * delta
	
	# crouching
	if Input.is_action_pressed("crouch") and Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		crouching = true
		SPEED = CROUCH_SPEED
		$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 1.5, 0.1)
		$head/AnimationPlayer.speed_scale = 1.0
	elif Input.is_action_just_released("crouch"):
		crouching = false
		SPEED = SPEED_DEFAULT
		$head/AnimationPlayer.speed_scale = 2.0
	if !Input.is_action_pressed("crouch"):
		$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 2.0, 0.1)

	$MeshInstance3D.mesh.height = $CollisionShape3D.shape.height
	$head.position.y = $CollisionShape3D.shape.height - 1.3

	# directional movement
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		if $head/AnimationPlayer.speed_scale != 2.0 and !Input.is_action_pressed("sprint") and !Input.is_action_pressed("crouch"):
			$head/AnimationPlayer.speed_scale = 2.0
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if Input.is_action_pressed("sprint") and !stamina_cooldown and !crouching:
			SPEED = SPRINT_SPEED
			stamina.visible = true
			$head/AnimationPlayer.speed_scale = 3.0
		if Input.is_action_just_released("sprint") and !crouching:
			SPEED = SPEED_DEFAULT
			stamina_cooldown = false
			$head/AnimationPlayer.speed_scale = 2.0
	else:
		if $head/AnimationPlayer.speed_scale != 0.0:
			$head/AnimationPlayer.speed_scale = 0.0
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# footstep sfx and speed
	distance += get_real_velocity().length() * delta
	if distance >= footstep_distance and is_on_floor():
		distance = 0
		if SPEED > 0:
			$footstep_audio.play()

	move_and_slide()

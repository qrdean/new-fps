class_name Player
extends CharacterBody3D


const SPEED = 5.0
const SPRINT_SPEED = 7.5

const JUMP_VELOCITY = 4.5
@export_range(0, 10, 0.01) var sensitivity : float = 3

@export var sprint_time: float = 5.0
@export var current_test: bool = false
@export var interact_distance: float = 2.0

@onready var weapon_rig: WeaponRig = %WeaponRig
@onready var ui_manager: UIManager = $UiManager

var inventory := []

var sprint_time_reset : float
var minPitch = deg_to_rad(-60)
var maxPitch = deg_to_rad(60)
var speed: float
var interact_cast_result

# @export var health: int = 100
var player_is_dead: bool = false
signal player_death(player, killer)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	sprint_time_reset = sprint_time
	weapon_rig.player = self


func _physics_process(delta: float) -> void:
	if player_is_dead:
		return

	if !current_test:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("shoot"):
		shoot()

	if Input.is_action_just_pressed("reload"):
		reload()

	if Input.is_action_just_pressed("swap_weapon"):
		swap_weapon()
	
	if Input.is_action_pressed("sprint"):
		speed = lerp(speed, SPRINT_SPEED, 0.5)
		sprint_time -= delta
		if sprint_time <= 0:
			speed = SPEED
	else:
		speed = SPEED
		if sprint_time < sprint_time_reset:
			sprint_time += delta * 2
	if ui_manager:
		ui_manager.update_sprint_bar(sprint_time, sprint_time_reset)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	interact_cast()

func _input(event):
	if player_is_dead:
		return

	if !current_test:
		return

	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / 1000 * sensitivity

		$Camera3D.rotation.x -= event.relative.y / 1000 * sensitivity

		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, minPitch, maxPitch)

		rotation.y = fmod(rotation.y, PI * 2)

	if Input.is_action_just_pressed("interact"):
		interact()

	if Input.is_action_just_pressed("dropitem"):
		drop_item()


func shoot():
	weapon_rig.shoot()

func reload():
	weapon_rig.reload()

func swap_weapon():
	weapon_rig.swap_weapon()

# func take_damage(damage: int, killer, head: bool = false):
# 	if head:
# 		health -= floori(damage * 1.5)
# 	else:
# 		health -= damage
#
# 	if health <= 0:
# 		die(killer)

func die(killer, body_part):
	print_debug('dead')
	print_debug(killer)
	print_debug(body_part)
	if !player_is_dead:
		player_death.emit(self, killer)
		player_is_dead = true

func respawn_player(spawn_point: Vector3, spawn_rotation: Vector3):
	global_position = spawn_point
	rotation = spawn_rotation
	player_is_dead = false

func _on_hit_box_manager_dead(killer, body_part) -> void:
	die(killer, body_part)

func interact_cast() -> void:
	var camera: Camera3D = $Camera3D
	var space_state := camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	var origin := camera.project_ray_origin(screen_center)
	var end := origin + camera.project_ray_normal(screen_center) * interact_distance
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	var result := space_state.intersect_ray(query)
	var current_cast_result = result.get("collider")
	if !is_instance_valid(interact_cast_result):
		interact_cast_result = null
	if current_cast_result != interact_cast_result:
		if interact_cast_result and interact_cast_result.has_user_signal("unfocused"):
			interact_cast_result.emit_signal("unfocused")
		interact_cast_result = current_cast_result
		if interact_cast_result and interact_cast_result.has_user_signal("focused"):
			interact_cast_result.emit_signal("focused")

func interact() -> void:
	if interact_cast_result and interact_cast_result.has_user_signal("interacted"):
		interact_cast_result.emit_signal("interacted", self)

func pickup_item(item_resource: Resource) -> bool:
	interact_cast_result = null
	inventory.push_back(item_resource)
	return true

func drop_item() -> void:
	var inventory_item = inventory.pop_front()
	if inventory_item is InventoryItemResource:
		var new_obj: Node3D = load(inventory_item.mesh_resource_path).instantiate()
		# TODO: Need to add this to the level Node feels weird it moves to the root here
		get_tree().root.add_child(new_obj)
		var camera: Camera3D = $Camera3D
		new_obj.global_position = global_position
		new_obj.global_position.x -= (camera.global_basis.z.x * 1.5)
		new_obj.global_position.z -= (camera.global_basis.z.z * 1.5)
		new_obj.global_position.y += (camera.global_basis.z.y * 2)

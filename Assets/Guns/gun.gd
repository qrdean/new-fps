class_name Gun
extends RigidBody3D

@export var barrel_gun_part: GunPartResource
@export var grip_gun_part: GunPartResource
@export var magazine_gun_part: GunPartResource
@export var stock_gun_part: GunPartResource
@export var sight_gun_part: GunPartResource

@export var test_base_resource: GunBaseResource
@export var test_inventory_resource: Array[MagazineRoundsContainer]

var gun_body: GunBody

var current_owner

@export var BulletPackedScene : PackedScene

@export var Ammo_pool : int = 40
var max_ammo_pool : int

@export var Current_ammo : int = 10
var max_current_ammo : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_attachments()
	max_ammo_pool = Ammo_pool
	max_current_ammo = Current_ammo
	gun_body.changed_magazine.connect(_put_mag_back)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if visible:
		# GameManager.ui_manager.update_ammo_count(Current_ammo, Ammo_pool)
		if current_owner and current_owner.ui_manager:
			var remaining_rounds = 0
			if gun_body.current_mag:
				remaining_rounds = gun_body.current_mag.get_round_count()
			current_owner.ui_manager.update_ammo_count(remaining_rounds, Ammo_pool)

func set_attachments():
	var new_gun_body = load(test_base_resource.gun_body_resource_path).instantiate()
	add_child(new_gun_body)
	gun_body = new_gun_body
	gun_body.rotate_y(deg_to_rad(90))
	gun_body.set_gun_resource(test_base_resource)
	if barrel_gun_part:
		gun_body.set_barrel_attachment(barrel_gun_part)
	
	if grip_gun_part:
		gun_body.set_grip_attachment(grip_gun_part)
		
	if magazine_gun_part:
		gun_body.set_magazine_attachment(magazine_gun_part)
		Current_ammo = gun_body.current_mag.get_round_count()
		# Current_ammo = magazine_gun_part.capacity
		
	if stock_gun_part:
		gun_body.set_stock_attachment(stock_gun_part)

	if sight_gun_part:
		gun_body.set_sight_attachment(sight_gun_part)

func Shoot():
	# if Current_ammo > 0 && visible:
	if gun_body.current_round != null && visible:
		var bullet : Bullet = BulletPackedScene.instantiate()
		bullet.set_stats(gun_body.current_round)
		gun_body.current_round = null
		bullet.playerId = current_owner
		get_tree().root.add_child(bullet)
		bullet.global_transform = $BulletSpawner.global_transform
		# Current_ammo -= 1
		$AnimationPlayer.play("Shoot")
		gun_body.cycle_round()

func Reload():
	if !visible:
		return

	# TODO: pull a mag from an inventory location. We'll currently spawn one instead
	var mag_round_container: MagazineRoundsContainer = test_inventory_resource.pop_front()
	var mag_gun_part = mag_round_container.magazine_stats
	# gun_body.set_magazine_attachment(magazine_gun_part)
	gun_body.set_magazine_attachment(mag_gun_part, mag_round_container.rounds)
	Current_ammo = gun_body.current_mag.get_round_count()
	# var bullet_resource762: BulletResource = preload("res://Resources/GunResources/BulletResource/762_round.tres")
	# var test_array: Array[BulletResource] = []
	# for i in 60:
	# 	test_array.push_back(bullet_resource762)
	#
	# if gun_body.current_mag:
	# 	gun_body.current_mag.fill_to_top(test_array)
	# 	gun_body.cycle_round()
	if gun_body.current_mag:
		gun_body.cycle_round()

	# FIXME: Remove me... Will need to be handled inventory space
	# if max_current_ammo > Ammo_pool:
	# 	Current_ammo = Ammo_pool
	# 	Ammo_pool = 0
	# else:
	# 	Current_ammo = max_current_ammo
	# 	Ammo_pool -= max_current_ammo

func _put_mag_back(mag_round_container: MagazineRoundsContainer) -> void:
	if mag_round_container:
		test_inventory_resource.push_back(mag_round_container)

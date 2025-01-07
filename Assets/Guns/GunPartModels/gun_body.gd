class_name GunBody
extends Node3D

signal changed_magazine(MagazineRoundsContainer)
signal empty()

@onready var mag_attach_point: Marker3D = $MagAttachPoint
@onready var grip_attach_point: Marker3D = $GripAttachPoint
@onready var barrel_attach_point: Marker3D = $BarrelAttachPoint
@onready var stock_attach_point: Marker3D = $StockAttachPoint
@onready var sight_attach_point: Marker3D = $SightAttachPoint

var current_round: BulletResource
var current_mag: Magazine
var current_barrel: Node3D
var current_stock: Node3D
var current_grip: Node3D
var current_sight: Node3D
var gun_resource: GunBaseResource

func set_gun_resource(gun_base_resource: GunBaseResource):
	gun_resource = gun_base_resource

func set_barrel_attachment(part_resource: GunPartResource) -> void:
	if gun_resource and !gun_resource.accepted_attachment_list.has(part_resource):
		printerr("invalid attachment")
		return

	if part_resource.part_type != part_resource.PartType.BARREL:
		printerr("not of type barrel")
		return
	var new_part = load(part_resource.gun_part_resource_path).instantiate()

	if current_barrel:
		var old_barrel = current_barrel
		old_barrel.queue_free()

	add_child(new_part)
	current_barrel = new_part
	current_barrel.position = barrel_attach_point.position

func set_magazine_attachment(part_resource: MagazineGunPartResource, rounds: Array[BulletResource] = []) -> Magazine:
	if gun_resource and !gun_resource.accepted_attachment_list.has(part_resource):
		printerr("invalid attachment")
		return null

	if part_resource.part_type != part_resource.PartType.MAGAZINE:
		printerr("not of type magazine")
		return null

	if gun_resource and part_resource.caliber != gun_resource.caliber:
		printerr("invalid caliber")
		return null

	var new_mag_obj: Magazine = load(part_resource.gun_part_resource_path).instantiate()
	new_mag_obj.magazine_stats = part_resource
	new_mag_obj.rounds = rounds

	var old_mag_stats: MagazineRoundsContainer = null
	if current_mag:
		var old_mag := current_mag
		old_mag_stats = old_mag.return_as_resource()
		old_mag.queue_free()

	add_child(new_mag_obj)

	# should play animation here.
	current_mag = new_mag_obj
	current_mag.position = mag_attach_point.position

	if !current_round and current_mag.get_round_count() > 0:
		current_round = current_mag.remove_round()
		if current_round == null:
			empty.emit()
	
	changed_magazine.emit(old_mag_stats)
	return current_mag

func reload_mag(part_resource: MagazineGunPartResource) -> Magazine:
	if gun_resource and !gun_resource.accepted_attachment_list.has(part_resource):
		printerr("invalid attachment")
		return null

	if part_resource.part_type != part_resource.PartType.MAGAZINE:
		printerr("not of type magazine")
		return null

	if gun_resource and part_resource.caliber != gun_resource.caliber:
		printerr("invalid caliber")
		return null

	var new_part: Magazine = load(part_resource.gun_part_resource_path).instantiate()
	new_part.magazine_stats = part_resource

	var old_mag_stats: MagazineRoundsContainer = null
	if current_mag:
		var old_mag := current_mag
		old_mag_stats = old_mag.return_as_resource()
		old_mag.queue_free()

	add_child(new_part)

	# should play animation here.
	current_mag = new_part
	current_mag.position = mag_attach_point.position

	if !current_round and current_mag.get_round_count() > 0:
		current_round = current_mag.remove_round()
		if current_round == null:
			empty.emit()
	
	changed_magazine.emit(old_mag_stats)
	return current_mag


func set_current_round_if_empty(bullet_resource: BulletResource) -> void:
	if !current_round:
		current_round = bullet_resource

func cycle_round() -> void:
	if !current_round:
		current_round = current_mag.remove_round()
		if current_round == null:
			empty.emit()

func set_grip_attachment(part_resource: GunPartResource) -> void:
	if gun_resource and !gun_resource.accepted_attachment_list.has(part_resource):
		printerr("invalid attachment")
		return

	if part_resource.part_type != part_resource.PartType.GRIP:
		printerr("not of type magazine")
		return

	var new_part = load(part_resource.gun_part_resource_path).instantiate()

	if current_grip:
		var old_grip = current_grip
		old_grip.queue_free()

	add_child(new_part)
	current_grip = new_part
	current_grip.position = grip_attach_point.position

func set_stock_attachment(part_resource: GunPartResource) -> void:
	if gun_resource and !gun_resource.accepted_attachment_list.has(part_resource):
		printerr("invalid attachment")
		return

	if part_resource.part_type != part_resource.PartType.STOCK:
		printerr("not of type stock")
		return

	var new_part = load(part_resource.gun_part_resource_path).instantiate()

	if current_stock:
		var old_stock = current_stock
		old_stock.queue_free()

	add_child(new_part)
	current_stock = new_part
	current_stock.position = stock_attach_point.position

func set_sight_attachment(part_resource: GunPartResource) -> void:
	if gun_resource and !gun_resource.accepted_attachment_list.has(part_resource):
		printerr("invalid attachment")
		return

	if part_resource.part_type != part_resource.PartType.SIGHT:
		printerr("not of type sight")
		return

	var new_part = load(part_resource.gun_part_resource_path).instantiate()

	if current_sight:
		var old_sight = current_sight
		old_sight.queue_free()

	add_child(new_part)
	current_sight = new_part
	current_sight.position = sight_attach_point.position

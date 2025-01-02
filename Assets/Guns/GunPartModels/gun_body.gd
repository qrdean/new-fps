class_name GunBody
extends Node3D

signal changed_magazine(GunPartResource)

@onready var mag_attach_point: Marker3D = $MagAttachPoint
@onready var grip_attach_point: Marker3D = $GripAttachPoint
@onready var barrel_attach_point: Marker3D = $BarrelAttachPoint
@onready var stock_attach_point: Marker3D = $StockAttachPoint
@onready var sight_attach_point: Marker3D = $SightAttachPoint

var current_mag: Node3D
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

func set_magazine_attachment(part_resource: MagazineGunPartResource) -> void:
	if gun_resource and !gun_resource.accepted_attachment_list.has(part_resource):
		printerr("invalid attachment")
		return

	if part_resource.part_type != part_resource.PartType.MAGAZINE:
		printerr("not of type magazine")
		return

	if gun_resource and part_resource.caliber != gun_resource.caliber:
		printerr("invalid caliber")
		return

	var new_part = load(part_resource.gun_part_resource_path).instantiate()

	if current_mag:
		var old_mag = current_mag
		old_mag.queue_free()

	add_child(new_part)

	# should play animation here.
	current_mag = new_part
	current_mag.position = mag_attach_point.position
	
	changed_magazine.emit(part_resource)

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

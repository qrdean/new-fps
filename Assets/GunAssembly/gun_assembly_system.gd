extends Node3D

enum PartType{
	BARREL,
	GRIP,
	MAGAZINE,
	STOCK,
	SIGHT
}

@export var barrel_gun_part_array: Array[GunPartResource]
@export var grip_gun_part_array: Array[GunPartResource]
@export var magazine_gun_part_array: Array[GunPartResource]
@export var stock_gun_part_array: Array[GunPartResource]
@export var sight_gun_part_array: Array[GunPartResource]

var barrel_gun_part_index: int = 0
var grip_gun_part_index: int = 0
var mag_gun_part_index: int = 0
var stock_gun_part_index: int = 0
var sight_gun_part_index: int = 0

@onready var gun_body: GunBody

@export var test_base_resource: GunBaseResource

func _ready() -> void:
	var new_gun_body = load(test_base_resource.gun_body_resource_path).instantiate()
	$RootBody.add_child(new_gun_body)
	gun_body = new_gun_body
	gun_body.set_gun_resource(test_base_resource)
	if barrel_gun_part_array.size() > 0:
		gun_body.set_barrel_attachment(barrel_gun_part_array[0])
	
	if grip_gun_part_array.size() > 0:
		gun_body.set_grip_attachment(grip_gun_part_array[0])
		
	if magazine_gun_part_array.size() > 0:
		gun_body.set_magazine_attachment(magazine_gun_part_array[0])
		
	if stock_gun_part_array.size() > 0:
		gun_body.set_stock_attachment(stock_gun_part_array[0])

	if sight_gun_part_array.size() > 0:
		gun_body.set_sight_attachment(sight_gun_part_array[0])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("swap_barrel"):
		barrel_gun_part_index = (barrel_gun_part_index + 1)
		
		if barrel_gun_part_index >= barrel_gun_part_array.size():
			barrel_gun_part_index = 0
		_swap_part(barrel_gun_part_array[barrel_gun_part_index], PartType.BARREL)
	
	if Input.is_action_just_pressed("swap_grip"):
		grip_gun_part_index = (grip_gun_part_index + 1)
		
		if grip_gun_part_index >= grip_gun_part_array.size():
			grip_gun_part_index = 0
		_swap_part(grip_gun_part_array[grip_gun_part_index], PartType.GRIP)

	if Input.is_action_just_pressed("swap_mag"):
		mag_gun_part_index = (mag_gun_part_index + 1)
		
		if mag_gun_part_index >= magazine_gun_part_array.size():
			mag_gun_part_index = 0
		_swap_part(magazine_gun_part_array[mag_gun_part_index], PartType.MAGAZINE)

	if Input.is_action_just_pressed("swap_stock"):
		stock_gun_part_index = (stock_gun_part_index + 1)
		if stock_gun_part_index >= stock_gun_part_array.size():
			stock_gun_part_index = 0
		_swap_part(stock_gun_part_array[stock_gun_part_index], PartType.STOCK)
	
	if Input.is_action_just_pressed("swap_sight"):
		sight_gun_part_index = (sight_gun_part_index + 1)
		if sight_gun_part_index >= sight_gun_part_array.size():
			sight_gun_part_index = 0
		_swap_part(sight_gun_part_array[sight_gun_part_index], PartType.SIGHT)
	
func _swap_part(part: GunPartResource, part_type: PartType) -> void:
	match part_type:
		PartType.BARREL:
			gun_body.set_barrel_attachment(part)
		PartType.STOCK:
			gun_body.set_stock_attachment(part)
		PartType.GRIP:
			gun_body.set_grip_attachment(part)
		PartType.MAGAZINE:
			gun_body.set_magazine_attachment(part)
		PartType.SIGHT:
			gun_body.set_sight_attachment(part)

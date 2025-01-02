class_name Rifle
extends Gun

@export var barrel_gun_part: GunPartResource
@export var grip_gun_part: GunPartResource
@export var magazine_gun_part: GunPartResource
@export var stock_gun_part: GunPartResource
@export var sight_gun_part: GunPartResource

@export var test_base_resource: GunBaseResource

var gun_body: GunBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		Current_ammo = magazine_gun_part.capacity
		
	if stock_gun_part:
		gun_body.set_stock_attachment(stock_gun_part)

	if sight_gun_part:
		gun_body.set_sight_attachment(sight_gun_part)
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

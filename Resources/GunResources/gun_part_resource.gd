class_name GunPartResource
extends InventoryItemResource

enum PartType{
	BARREL,
	GRIP,
	MAGAZINE,
	STOCK,
	SIGHT
}

@export var gun_part_resource_path: String
@export var part_type: PartType

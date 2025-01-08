class_name InventoryItemResource
extends Resource

enum ItemType {
	LOOT,
	WEAPON_PART,
	BULLET
}

@export var mesh_resource_path: String
@export var name: String
@export var height: int = 1
@export var width: int = 1
@export var item_type: ItemType

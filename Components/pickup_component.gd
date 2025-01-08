class_name PickupComponent
extends Node

signal picked_up_item(InventoryItemResource)

@export var item_resource: InventoryItemResource

var parent

func _ready() -> void:
	parent = get_parent()
	if parent is InteractionComponent:
		parent.player_interacted.connect(pickup_item)

func pickup_item(object: Node3D, player: Player) -> void:
	print_debug("picked up obj: " + str(object))
	print_debug("picked up by: " + str(player))
	if player:
		var picked_up := player.pickup_item(item_resource)
		if picked_up:
			picked_up_item.emit(item_resource)

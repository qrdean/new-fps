class_name InventoryManager
extends Node3D

@export var mag_pockets: Array[MagazineRoundsContainer] = []
var pocket_size = 4

# Need to move stacks to an item resource class
@export var bullet_stack: Array[BulletResource] = []
var max_stack_size = 60


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

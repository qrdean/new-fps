class_name InteractionComponent
extends Node

signal player_interacted(object, player)

@export var context: String = ""
@export var override_icon: bool = false
@export var new_icon: Texture2D = null

var mesh
var parent
var highlight_material = preload("res://Assets/Materials/interactable_highlight.tres")

func _ready() -> void:
	parent = get_parent()
	connect_parent()
	set_default_mesh()
	setup_children()

func in_range() -> void:
	# parent.focused.emit()
	print_debug(mesh)
	if mesh:
		mesh.material_overlay = highlight_material
	MessageBus.interaction_focused.emit(context, new_icon, override_icon)

func not_in_range() -> void:
	# parent.unfocused.emit()
	if mesh:
		mesh.material_overlay = null
	MessageBus.interaction_unfocused.emit()

func on_interact(interacter: Player) -> void:
	print_debug("something")
	print_debug(parent.name)
	print_debug(interacter)
	player_interacted.emit(parent, interacter)

func connect_parent() -> void:
	parent.add_user_signal("focused")
	parent.add_user_signal("unfocused")
	parent.add_user_signal("interacted")

	parent.connect("focused", Callable(self, "in_range"))
	parent.connect("unfocused", Callable(self, "not_in_range"))
	parent.connect("interacted", Callable(self, "on_interact"))

func set_default_mesh() -> void:
	if mesh:
		pass
	else:
		for i in parent.get_children():
			if i is CSGMesh3D or i is MeshInstance3D:
				mesh = i

func setup_children() -> void:
	for i in get_children():
		if i.has_signal("picked_up_item"):
			i.connect("picked_up_item", Callable(self, "remove_object"))

func remove_object(_resource: Resource) -> void:
	not_in_range()
	parent.remove_user_signal("focused")
	parent.remove_user_signal("unfocused")
	parent.remove_user_signal("interacted")
	parent.queue_free()

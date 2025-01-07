class_name InteractionComponent
extends Node

var parent

func _ready() -> void:
	parent = get_parent()
	connect_parent()

func in_range() -> void:
	# parent.focused.emit()
	print_debug(parent)

func not_in_range() -> void:
	# parent.unfocused.emit()
	pass

func on_interact() -> void:
	print_debug("something")
	print_debug(parent.name)

func connect_parent() -> void:
	parent.add_user_signal("focused")
	parent.add_user_signal("unfocused")
	parent.add_user_signal("interacted")
	parent.connect("focused", Callable(self, "in_range"))
	parent.connect("unfocused", Callable(self, "not_in_range"))
	parent.connect("interacted", Callable(self, "on_interact"))

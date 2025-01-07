class_name WeaponRig
extends Marker3D

var player
var weapons_array: Array[Gun]
var current_weapon_idx = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent()
	_init_weapons()


func _init_weapons():
	for i in range(get_child_count()):
		if get_child(i) is Gun:
			get_child(i).current_owner = player
			get_child(i).hide()
			weapons_array.push_back(get_child(i))
	weapons_array[current_weapon_idx].show()

func shoot():
	weapons_array[current_weapon_idx].Shoot()

func reload():
	weapons_array[current_weapon_idx].Reload()

func swap_weapon():
	weapons_array[current_weapon_idx].visible = false

	current_weapon_idx += 1
	if current_weapon_idx >= weapons_array.size():
		current_weapon_idx = 0

	weapons_array[current_weapon_idx].visible = true

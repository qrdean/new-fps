class_name Magazine
extends Node3D

var stats: MagazineGunPartResource

@export var rounds: Array[BulletResource]

func add_round(bullet_resource: BulletResource) -> bool:
	if rounds.size() < stats.capacity:
		rounds.push_back(bullet_resource)

	return rounds.size() >= stats.capacity

func fill_to_top(bullet_resource_array: Array[BulletResource]) -> bool:
	print_debug(stats.capacity)
	
	while rounds.size() < stats.capacity and bullet_resource_array.size() > 0:
		if rounds.size() < stats.capacity:
			rounds.push_back(bullet_resource_array.pop_back())
	return rounds.size() >= stats.capacity

func get_round_count() -> int:
	return rounds.size()

# func fire_round() -> BulletResource:
# 	return rounds.pop_back()

func remove_round() -> BulletResource:
	return rounds.pop_back()

class_name Magazine
extends Node3D

var magazine_stats: MagazineGunPartResource

@export var rounds: Array[BulletResource]

func add_round(bullet_resource: BulletResource) -> bool:
	if rounds.size() < magazine_stats.capacity:
		rounds.push_back(bullet_resource)

	return rounds.size() >= magazine_stats.capacity

func fill_to_top(bullet_resource_array: Array[BulletResource]) -> bool:
	print_debug(magazine_stats.capacity)
	
	while rounds.size() < magazine_stats.capacity and bullet_resource_array.size() > 0:
		if rounds.size() < magazine_stats.capacity:
			rounds.push_back(bullet_resource_array.pop_back())
	return rounds.size() >= magazine_stats.capacity

func get_round_count() -> int:
	return rounds.size()

# func fire_round() -> BulletResource:
# 	return rounds.pop_back()

func remove_round() -> BulletResource:
	return rounds.pop_back()

func return_as_resource() -> MagazineRoundsContainer:
	var magazine_rounds_container := MagazineRoundsContainer.new()
	magazine_rounds_container.magazine_stats = magazine_stats
	magazine_rounds_container.rounds = rounds
	return magazine_rounds_container

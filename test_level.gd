extends Node3D


func _on_player_player_death(_player: Variant, _killer: Variant) -> void:
	pass # Replace with function body.


func _on_player_2_player_death(player: Player, killer: Player) -> void:
	print_debug(killer.name)
	player.respawn_player($RespawnPoint.global_position, Vector3.ZERO)

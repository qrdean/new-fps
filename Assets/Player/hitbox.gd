class_name HitBox
extends Area3D

signal hit(damage_amount: int, player: Node3D)

func take_damage(damage_amount: int, player):
	print_debug('damage' + str(damage_amount))
	hit.emit(damage_amount, player)

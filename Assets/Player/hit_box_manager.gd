class_name HitBoxManager
extends Node3D

var player

signal dead(killer, body_part)
@export var head_health: int = 35
@export var torso_health: int = 75
@export var left_arm_health: int = 55
@export var right_arm_health: int = 55
@export var left_leg_health: int = 55
@export var right_leg_health: int = 55

var remaining_limbs: int = 6

func _ready() -> void:
	player = get_parent()

func _process(_delta: float) -> void:
	if player and player.ui_manager:
		player.ui_manager.update_health_ui(total_health(), head_health, torso_health, left_leg_health, right_leg_health, left_arm_health, right_arm_health)

func total_health() -> int:
	return head_health + torso_health + left_arm_health + left_leg_health + right_arm_health + right_leg_health

func _damage_all(damage_amount: int, killer) -> void:
	var spread_damage: int = floori(damage_amount / remaining_limbs)
	head_health -= spread_damage
	torso_health -= spread_damage
	if head_health <= 0 || torso_health <= 0:
		dead.emit(killer, 'head or torso')
	
	if left_leg_health > 0:
		left_leg_health -= spread_damage
		if left_leg_health <= 0:
			remaining_limbs -= 1

	if right_leg_health > 0:
		right_leg_health -= spread_damage
		if right_leg_health <= 0:
			remaining_limbs -= 1

	if right_arm_health > 0:
		right_arm_health -= spread_damage
		if right_arm_health <= 0:
			remaining_limbs -= 1

	if left_arm_health > 0:
		left_arm_health -= spread_damage
		if left_arm_health <= 0:
			remaining_limbs -= 1

func _on_head_hit(damage_amount: int, killer) -> void:
	if !player.player_is_dead:
		head_health -= damage_amount
		if head_health <= 0:
			dead.emit(killer, 'head')

func _on_right_leg_hit(damage_amount: int, killer) -> void:
	if !player.player_is_dead:
		right_leg_health -= damage_amount
		if right_leg_health <= 0:
			remaining_limbs -= 1
			_damage_all(damage_amount, killer)


func _on_left_leg_hit(damage_amount: int, killer) -> void:
	if !player.player_is_dead:
		left_leg_health -= damage_amount
		if left_leg_health <= 0:
			_damage_all(damage_amount, killer)


func _on_right_arm_hit(damage_amount: int, killer) -> void:
	if !player.player_is_dead:
		right_arm_health -= damage_amount
		if right_arm_health <= 0:
			_damage_all(damage_amount, killer)


func _on_left_arm_hit(damage_amount: int, killer) -> void:
	if !player.player_is_dead:
		left_arm_health -= damage_amount
		if left_arm_health <= 0:
			# all damage
			_damage_all(damage_amount, killer)


func _on_torso_hit(damage_amount: int, killer) -> void:
	if !player.player_is_dead:
		torso_health -= damage_amount
		if torso_health <= 0:
			dead.emit(killer, 'torso')

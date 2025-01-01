class_name UIManager
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !get_parent().current_test:
		self.hide()
		return
	GameManager.ui_manager = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_ammo_count(current_ammo_count : int, current_ammo_pool: int):
	var style = '[center][b]' 
	$AmmoPanel/CurrentAmmoCount.text = style + str(current_ammo_count)
	$AmmoPanel/CurrentAmmoPool.text = style + str(current_ammo_pool)

func update_sprint_bar(sprint_time: float, sprint_time_reset: float):
	$SprintBar.max_value = sprint_time_reset
	$SprintBar.value = sprint_time

func update_health_ui(total_health: int, head_health: int, torso_health: int, l_leg_health: int, r_leg_health: int, l_arm_health: int, r_arm_health: int):
	var style = '[left][b]'
	$HealthPanel/TotalHealth.text = style + 'Total: ' + str(total_health)
	$HealthPanel/Head.text = style + 'Head: ' + str(head_health)
	$HealthPanel/Torso.text = style + 'Torso: ' + str(torso_health)
	$HealthPanel/LeftLeg.text = style + 'Left Leg: ' + str(l_leg_health)
	$HealthPanel/RightLeg.text = style + 'Right Leg: ' + str(r_leg_health)
	$HealthPanel/LeftArm.text = style + 'Left Arm: ' + str(l_arm_health)
	$HealthPanel/RightArm.text = style + 'Right Arm: ' + str(r_arm_health)

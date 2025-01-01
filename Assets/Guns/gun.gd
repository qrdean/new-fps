class_name Gun
extends RigidBody3D

var current_owner

@export var BulletPackedScene : PackedScene

@export var Ammo_pool : int = 40
var max_ammo_pool : int

@export var Current_ammo : int = 10
var max_current_ammo : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_ammo_pool = Ammo_pool
	max_current_ammo = Current_ammo

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if visible:
		# GameManager.ui_manager.update_ammo_count(Current_ammo, Ammo_pool)
		if current_owner and current_owner.ui_manager:
			current_owner.ui_manager.update_ammo_count(Current_ammo, Ammo_pool)

func Shoot():
	if Current_ammo > 0 && visible:
		var bullet : Bullet = BulletPackedScene.instantiate()
		bullet.playerId = current_owner
		get_tree().root.add_child(bullet)
		bullet.global_transform = $BulletSpawner.global_transform
		Current_ammo -= 1

		$AnimationPlayer.play("Shoot")

func Reload():
	if !visible:
		return

	if max_current_ammo > Ammo_pool:
		Current_ammo = Ammo_pool
		Ammo_pool = 0
	else:
		Current_ammo = max_current_ammo
		Ammo_pool -= max_current_ammo

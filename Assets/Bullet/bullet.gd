class_name Bullet
extends Area3D

@export var SPEED : float = 1.0
@export var damage : int = 1
var time_to_live : float = 2000.0
var playerId


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position + -global_transform.basis.z * SPEED
	position.y = position.y + gravity * delta
	time_to_live -= delta
	if time_to_live <= 0:
		queue_free()


func _on_area_entered(area: Area3D) -> void:
	if area is HitBox:
		area.take_damage(damage, playerId)

class_name Pistol
extends Gun

@export var rounds: Array[BulletResource]
var bullet_resource762: BulletResource = preload("res://Resources/GunResources/BulletResource/762_round.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 60:
		rounds.push_back(bullet_resource762)
	super()
	if gun_body.current_mag:
		gun_body.current_mag.fill_to_top(rounds)
		gun_body.cycle_round()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

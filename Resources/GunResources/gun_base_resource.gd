class_name GunBaseResource
extends Resource

enum GunType {
	PISTOL,
	RIFLE
	# shotgun
	# marksman
	# smg
}

@export var gun_body_resource_path: String
@export var gun_type: GunType
@export var caliber: String

@export var accepted_attachment_list: Array[GunPartResource]


# add base gun stats here

extends Node2D
@onready var ik_target = $IKTarget
@onready var hand: Bone2D = $ClawSkeleton/Arm/Forearm/Hand

func _process(delta):
	ik_target.global_position = get_global_mouse_position()

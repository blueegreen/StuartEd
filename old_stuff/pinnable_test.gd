extends RigidBody2D

var pin : PinJoint2D = null
var collision_info := {}

func _ready():
	#InputManager.interaction_started.connect(_on_click)
	InputManager.mouse_released.connect(_on_release)
	collision_info = {"collision_layer" = collision_layer, "collision_mask" = collision_mask}

func _on_release():
	if pin:
		pin.queue_free()
		collision_layer = collision_info.collision_layer
		collision_mask = collision_info.collision_mask
	pass

#func _on_click(clicked_node):
	#if clicked_node != self:
		#return
	#if pin:
		#pin.queue_free()
		#await get_tree().process_frame
	#pin = PinJoint2D.new()
	#pin.node_a = MouseAnchor.get_path()
	#pin.node_b = self.get_path()
	#MouseAnchor.add_child(pin)
	#collision_layer = 0
	#collision_mask = 0

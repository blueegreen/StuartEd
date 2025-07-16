extends Node2D
class_name test_level_progress

#simply store all flags for level_progress
#for this test, let's say: talked to A, talked to A2
#unique class for each level - all things that advance level_progress have access to this script

var talked_to_A := false
var talked_to_A2 := false

var config = ConfigFile.new()

func _ready() -> void:
	return

func event_is_active_write(level: String, event: String, is_active: bool):
	#Enter Level as String like Level1, Event as Sting, is_Active as bool
	config.set_value(level,event,is_active)
	var error = config.save("user://save_game.cfg")
	if error != OK:
		print("Failed to save config: ", error)

func event_is_active_read(level: String, event: String):
	
	var file = config.load("user://savegame.cfg")
	if file != OK:
		print("Failed to load config: ", file)
		return
	config.get_value(level,event)

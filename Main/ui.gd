extends CanvasLayer


func _on_back_button_down():
	get_tree().change_scene_to_file("res://Main/new_level_selector.tscn")


func _on_reload_button_down():
	get_tree().reload_current_scene()

extends Node
class_name ContextData

#format : {"speaker_name" : speaker_node_path}

@export var speakers : Dictionary = {}

func get_speaker(speaker_name: String) -> Node2D:
	if speakers.has(speaker_name):
		var node = get_node(speakers[speaker_name])
		if node:
			return node
		push_warning("Speaker " + speaker_name + " found but path is invalid")
	else:
		push_warning("Speaker " + speaker_name + " not found in context")
	return null

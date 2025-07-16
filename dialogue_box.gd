extends RichTextLabel
class_name dialogue_box

#@export var dict : Dictionary = {"Message":"@","Animation":0}
#
##func _ready() -> void:
	##self.text =""
	##set_custom_text(dict["Message"],dict["Animation"])
##
##func append_chat_line(object, message):
	##append_text("[wave]%s: [color=green]%s[/color][/wave]\n" % [object, message])

#func _process(delta):
	#if Input.is_action_just_pressed("click"):
		#set_custom_text("hello there", randi_range(0, 5))

func set_custom_text(message: String, animation: int = 0):
	text = ""
	match animation:
		0:
			append_text(message)
		1:
			append_text("[pulse]"+ message +"[/pulse]")
		2:
			append_text("[wave]"+ message +"[/wave]")
		3:
			append_text("[tornado]"+ message +"[/tornado]")
		4:
			append_text("[shake]"+ message +"[/shake]")
		5:
			append_text("[rainbow]"+ message +"[/rainbow]")
		_:
			append_text(message)

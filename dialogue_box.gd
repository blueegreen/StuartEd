extends RichTextLabel
class_name dialogue_box
@export var dict : Dictionary = {"Message":"@","Animation":0}

func _ready() -> void:
	self.text =""
	append_monlogue_line(dict["Message"],dict["Animation"])

func append_chat_line(object, message):
	append_text("[wave]%s: [color=green]%s[/color][/wave]\n" % [object, message])

func append_monlogue_line(message :String,animation : int = 0):
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

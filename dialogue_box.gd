extends RichTextLabel

func _ready() -> void:
	self.text =""
	append_chat_line("player","hello")

func append_chat_line(object, message):
	append_text("[wave]%s: [color=green]%s[/color][/wave]\n" % [object, message])

func append_monlogue_line(message :String,animation : int):
	if animation == 0:
		append_text("[wave]" + message +"[/wave]")

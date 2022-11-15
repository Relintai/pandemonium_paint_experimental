tool
extends Node2D #PaintNode

export(Vector2i) var image_size : Vector2i = Vector2i(64, 64)

export(String) var image_file_name : String
export(int, "png") var image_type : int

# manages Grid, and BG's size
# also lets you hide them, so custom ones can be created
# could have an api to register backgorund layers and then it will resize them

# Image size will only affect rendering at the end when saving the image

func save_image() -> void:
	pass

func _get_property_list() -> Array:
	return [
		{
			"type": TYPE_NIL,
			"name": "save_image",
			"hint": PROPERTY_HINT_BUTTON,
			"hint_string": "save_image:Save/EditorIcons"
		}
		
	]

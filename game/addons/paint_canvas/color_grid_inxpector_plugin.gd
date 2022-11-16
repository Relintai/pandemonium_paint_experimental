tool
extends EditorInspectorPlugin

func can_handle(object: Object) -> bool:
	return object is PaintNode
	

func parse_begin(object: Object) -> void:
	add_custom_control(PaintColorGrid.new())

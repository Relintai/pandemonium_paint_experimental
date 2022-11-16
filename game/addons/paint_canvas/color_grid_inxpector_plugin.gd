tool
extends EditorInspectorPlugin

func can_handle(object: Object) -> bool:
	return object is PaintNode
	
func parse_begin(object: Object) -> void:
	var pc : PaintColorGrid = PaintColorGrid.new()
	pc.on_paint_node_selected(object)
	add_custom_control(pc)

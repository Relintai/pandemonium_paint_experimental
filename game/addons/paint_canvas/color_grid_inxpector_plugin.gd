tool
extends EditorInspectorPlugin

func can_handle(object: Object) -> bool:
	return object is PaintNode
	
func parse_begin(object: Object) -> void:
	var pc : PaintProjectPropertyInspector = PaintProjectPropertyInspector.new()
	pc.on_paint_node_selected(object)
	add_custom_control(pc)
	
	if object is PaintCanvas:
		var ptool : PaintToolsPropertyInspector = PaintToolsPropertyInspector.new()
		ptool.on_paint_node_selected(object)
		add_custom_control(ptool)

tool
extends PaintProject


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# add button that ads bg and visual grid, also should set owner so they get saved
# canvas bg make it not use shader
# inherit both from PaintNode -> automatic easy resize

# Implement trickle down resize -> PAitnProject resized -> NOTIFICATION PAINT PROJECT RESIZED!

# PaintNode -> current size property read only
# Resize property + resize button

# Mouse pos for the canvas property inspector

# PaintProj -> Collect and merge and save -> NOTIF PaintProject PRE Save , then get image()
# should be saved virtual! only true for canvas for now

# PaintCanvas -> LoadImage

# PaintNodes -> Outline property. Maybe keep node?

# PaintCanvas -> save data in a compressed form

# port back everything to c++

# remove old deprecated classes




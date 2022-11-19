tool
extends PaintProject

# PaintCanvas -> save data in a compressed form ? -> this is probably the best
# lz4 -> add lz4 module, remove multiple lz4 implementations

# PaintProj -> Collect and merge and save -> NOTIF PaintProject PRE Save , then get image()
# should be saved virtual! only true for canvas for now
# Should apply transforms aswell -> different projects could be put together using scene instancing

# PaintProject -> new tool, which is only present when its selected:
# ExportImage, Load image as new canvas, scale project tool, and add other run properties to it.

# PaintCanvas -> LoadCanvasImage, exportCanvasImage -> TOOL
# PaintCanvas -> scale tool
# Mouse pos for the canvas property inspector

# Port the inspector plugin to c++ aswell

# remove old deprecated classes
# inherit both PaintVisualGrid and PaintCanvasBackground from PaintNode -> automatic easy resize
# Rename the paint project editor which is present for all nodes to PaintNode editor

# Rename the method that is used to set the inspected PaintNodes in PaintCustomPropertyInspector

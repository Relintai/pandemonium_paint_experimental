extends Node2D

# Canvas that can be used to draw on

# Should probably store it's actual data in an lz4 compressed poolvector property 
# like what voxelman does

# Undo history should be handled by the editor itself

# It could use the paint module's actions for manipulation

# it could have a drag and drop image property so things can be dropped into it

# could be "infinite", so ti does not need to mess with resizes -> needs chunks though
# if needed this should likely be an another class, like an InifinePaintCanvas or ChunkedPaintCanvas

# better for now:
# it could have it's own size -> when added to the tree it should copy the size of it's
# parent paint project
# then it should have a resize button with properties, ot it's sidebar module should have a button
# + popup to handle resizes

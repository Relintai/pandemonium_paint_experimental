extends Path2D

export(int, "append,union,sub,simdiff,etc...") var operation : int = 0

# The renderer should process each child one by one in tree order
# A render needs to start with a curve with an append operation
# apply all non append curves to the last append curve
# render it when out of children or when the next append curve is reached

# It could just render only one append curves aswell, it could warn if you have more than one
# This will need testing

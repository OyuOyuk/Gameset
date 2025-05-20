
extends Resource
class_name item_recipe

# Define properties WITHOUT the enum hint
@export var recipe_id: String # Recipe's own unique ID
@export var output_item : Inventory_Item 
@export var output_amount : int = 1
@export var ingredients : Array[recipe_ingredient]

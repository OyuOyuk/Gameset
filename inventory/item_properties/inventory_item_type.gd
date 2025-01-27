extends Resource
class_name Inventory_Properties
enum Type {TOOL, FOOD, MATERIAL}
@export var type : Type
#tool
@export var durability : int = -1
@export var tool_type : String = ""
@export var tool_material : String = ""
#food
@export var food_value : int = -1
@export var food_effect : String = ""

#material
@export var burnable :bool = false

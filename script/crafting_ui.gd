extends Control
@onready var recipes = load("res://inventory/recipe/known_recipes.tres")
@onready var list_container = $ScrollContainer/recipe_list_container
@export var recipe_item : PackedScene
var known_recipes = []
var is_open = false
func _ready():
	ConnectionManager.connect("recipe_clicked", recipe_clicked)
func load_recipes():
	for recipe in recipes.recipes:
		if recipe not in known_recipes:
			known_recipes.append(recipe)
func spawn_recipes():
	for recipe in known_recipes:
		if not list_container.find_child(recipe.output_item.name, false, false):
			var recipe_box = recipe_item.instantiate()
			var labelname = recipe_box.get_node("HBoxContainer/nameLabel") 
			var icon = recipe_box.get_node("HBoxContainer/iconRect") 
			recipe_box.associated_recipe_data = recipe
			labelname.text = recipe.output_item.name
			icon.texture = recipe.output_item.texture
			recipe_box.name = recipe.output_item.name
			
			list_container.add_child(recipe_box)
func recipe_clicked(recipe_data):
	print(recipe_data.output_item.name)
func close():
	visible = false
	is_open = false
func open():
	load_recipes()
	spawn_recipes()
	visible = true
	is_open = true
func _input(event):
	if Input.is_action_just_pressed("crafting"):
		if is_open:
			close()
		else :
			open()

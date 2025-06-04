extends Control
@onready var inventory : Inventory = preload("res://inventory/player_inventory.tres")
@onready var recipes = load("res://inventory/recipe/known_recipes.tres")
@onready var list_container = $ScrollContainer/recipe_list_container
@onready var item_sprite = $recipeContainer/item_sprite
@onready var item_name = $recipeContainer/Item_name
@onready var recipe_ingredients = $recipeContainer/ScrollContainer/recipe_ingredients
@export var recipe_item : PackedScene
@export var ingredient_item : PackedScene

var known_recipes = []
var open_recipe 
var is_open = false
func _ready():
	visible = false
	ConnectionManager.connect("recipe_clicked", recipe_clicked)
	open_recipe = recipes.recipes[0]
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
	open_recipe = recipe_data
	item_name.text = recipe_data.output_item.name
	item_sprite.texture = recipe_data.output_item.texture
	change_out_recipe(recipe_data)
func change_out_recipe(recipe_data):
	
	for ingredient in recipe_data.ingredients:
		var item =  ingredient_item.instantiate()
		item.get_node("HBoxContainer/text").text = ingredient.item.name
		item.get_node("HBoxContainer/amount").text =  str(ingredient.amount) 
		item.get_node("icon").texture = ingredient.item.texture
		recipe_ingredients.add_child(item)
func close():
	visible = false
	is_open = false
	for child_node in recipe_ingredients.get_children():
		child_node.queue_free() 
func open():
	load_recipes()
	spawn_recipes()
	item_name.text = open_recipe.output_item.name
	item_sprite.texture = open_recipe.output_item.texture
	change_out_recipe(open_recipe)
	visible = true
	is_open = true
func _input(event):
	if Input.is_action_just_pressed("crafting"):
		if is_open:
			close()
		else :
			open()


func _on_craft_button_pressed():
	var check
	for ingredient in open_recipe.ingredients:
		if inventory.search(ingredient.item, ingredient.amount):
			check = true
		else:
			check = false
			break
	if check == true:
		for ingredient in open_recipe.ingredients:
			inventory.remove(ingredient.item, ingredient.amount)
		inventory.insert(open_recipe.output_item, open_recipe.output_amount)

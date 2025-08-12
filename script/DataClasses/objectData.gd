extends Node2D
class_name objectData

var object_id = null
var interactable = false

var plant : PlantData = null 
var feature : FeatureData = null
var rock = Vector2i(0,0)
var minerals
var broken_by = []

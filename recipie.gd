extends Control

@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var ingredients_v_box_container: VBoxContainer = $MarginContainer/VBoxContainer/IngredientsVBoxContainer
@onready var notes_label: Label = $MarginContainer/VBoxContainer/NotesLabel
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer

@onready var ingredient_amount_label: Label = $MarginContainer/VBoxContainer/IngredientsVBoxContainer/HBoxContainer/IngredientAmountLabel
@onready var h_box_container: HBoxContainer = $MarginContainer/VBoxContainer/IngredientsVBoxContainer/HBoxContainer
@onready var name_label: Label = $MarginContainer/VBoxContainer/MarginContainer/NameLabel
@onready var ingredient_name_label: Label = $MarginContainer/VBoxContainer/IngredientsVBoxContainer/HBoxContainer/MarginContainer/IngredientNameLabel



func _ready() -> void:
	self.custom_minimum_size = get_viewport_rect().size
	v_box_container.custom_minimum_size = Vector2(get_viewport_rect().size.x, 0)
	texture_rect.custom_minimum_size = get_viewport_rect().size*0.3

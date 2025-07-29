extends Control

#@onready var poster_texture_rect: TextureRect = $MarginContainer/VBoxContainer/PosterTextureRect
@onready var color_rect: ColorRect = $MarginContainer/ColorRect
@onready var premiere_label: Label = $MarginContainer/VBoxContainer/PremiereLabel
@onready var duration_label: Label = $MarginContainer/VBoxContainer/DurationLabel
@onready var genres_label: Label = $MarginContainer/VBoxContainer/GenresLabel
@onready var rating_kp_label: Label = $MarginContainer/VBoxContainer/RatingKPLabel
@onready var rating_imdb_label: Label = $MarginContainer/VBoxContainer/RatingIMDBLabel
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var name_label: Label = $MarginContainer/VBoxContainer/MarginContainer/NameLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/DescriptionLabel


func _ready() -> void:
	for child in v_box_container.get_children():
		if child.get_children():
			for child2 in child.get_children():
				child2.custom_minimum_size = Vector2(get_viewport_rect().size.x*0.8, 0)
		child.custom_minimum_size = Vector2(get_viewport_rect().size.x*0.8, 0)


func _on_button_pressed() -> void:
	queue_free()

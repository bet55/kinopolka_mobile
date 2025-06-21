extends Node2D

@onready var icon: Sprite2D = $Icon
@onready var movies: Node2D = $Movies
@onready var archieve: Node2D = $Archieve
@onready var main_interface: Node2D = $MainInterface


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(icon, "rotation_degrees", 360, 1)
	tween.tween_property(main_interface, "position", Vector2(0, 0), 1)#.set_ease(Tween.EASE_OUT)


func show_main_interface():
	var main_interface_tween = create_tween()
	main_interface_tween.tween_property(main_interface, "global_position", Vector2(0, 0), 1).set_ease(Tween.EASE_OUT)


func show_archieve():
	var archieve_tween = create_tween()
	archieve_tween.tween_property(main_interface, "global_position", Vector2(-1080, 0), 1).set_ease(Tween.EASE_OUT)


func show_movies():
	var movies_tween = create_tween()
	movies_tween.tween_property(main_interface, "global_position", Vector2(0, 0), 1).set_ease(Tween.EASE_OUT)

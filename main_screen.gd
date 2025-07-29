extends Control

@onready var move_control: Control = $MoveControl
@onready var camera_2d: Camera2D = $Camera2D
@onready var movies: ScrollContainer = $MoveControl/Movies
@onready var archieve: ScrollContainer = $MoveControl/Archieve
@onready var bar: ScrollContainer = $MoveControl/Bar


func _ready() -> void:
	bar.global_position = Vector2(get_viewport_rect().size.x * -1, 0)
	movies.global_position = Vector2(get_viewport_rect().size.x * 0, 0)
	archieve.global_position = Vector2(get_viewport_rect().size.x * 1, 0)


func _on_movies_button_pressed() -> void:
	var move_tween = create_tween()
	move_tween.tween_property(camera_2d, 'global_position', get_viewport_rect().get_center(), 0.2).set_ease(Tween.EASE_IN_OUT)


func _on_archieve_button_pressed() -> void:
	var move_tween = create_tween()
	move_tween.tween_property(camera_2d, 'global_position', get_viewport_rect().get_center() + Vector2(get_viewport_rect().size.x, 0), 0.2).set_ease(Tween.EASE_IN_OUT)


func _on_bar_texture_button_pressed() -> void:
	var move_tween = create_tween()
	move_tween.tween_property(camera_2d, 'global_position', get_viewport_rect().get_center() - Vector2(get_viewport_rect().size.x, 0), 0.2).set_ease(Tween.EASE_IN_OUT)

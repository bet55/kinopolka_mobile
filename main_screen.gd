extends Control

@onready var move_control: Control = $MoveControl
@onready var camera_2d: Camera2D = $Camera2D


func _ready() -> void:
	var children = move_control.get_children()
	for i in range(2):
		children[i].global_position = Vector2(get_viewport_rect().size.x * i, 0)


func _on_movies_button_pressed() -> void:
	var move_tween = create_tween()
	move_tween.tween_property(camera_2d, 'global_position', get_viewport_rect().get_center(), 0.2).set_ease(Tween.EASE_IN_OUT)


func _on_archieve_button_pressed() -> void:
	var move_tween = create_tween()
	move_tween.tween_property(camera_2d, 'global_position', get_viewport_rect().get_center() + Vector2(get_viewport_rect().size.x, 0), 0.2).set_ease(Tween.EASE_IN_OUT)

extends Control

@export var swipe_threshold := 0.3
@export var swipe_speed := 15.0
@export var screens_margin := 0
@export var direction_threshold := 50.0  # Порог в пикселях для определения направления

var screens := []
var current_screen := 0
var target_position := Vector2.ZERO
var drag_start_position := Vector2.ZERO
var container_start_position := Vector2.ZERO
var dragging := false
var can_swipe := true
var swipe_direction_locked := false  # Флаг блокировки направления
var initial_drag_direction := 0  # 0 - не определено, 1 - горизонтальное, 2 - вертикальное

func _ready():
	for child in get_children():
		if child is Control:
			screens.append(child)
	
	_arrange_screens()
	gui_input.connect(_on_gui_input)
	target_position = position

func _arrange_screens():
	for i in screens.size():
		var screen = screens[i]
		screen.position.x = i * (size.x + screens_margin)
		screen.size = size

func _process(delta):
	if not dragging:
		position.x = lerp(position.x, target_position.x, swipe_speed * delta)
		if abs(position.x - target_position.x) < 0.5:
			position.x = target_position.x
	
	position.x = clamp(position.x, 
					 -((screens.size()-1) * (size.x + screens_margin)), 
					 0)

func _on_gui_input(event):
	if not can_swipe:
		return
	
	if event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
			drag_start_position = event.position
			container_start_position = position
			swipe_direction_locked = false
			initial_drag_direction = 0
		else:
			dragging = false
			_check_swipe_threshold()
	
	elif event is InputEventScreenDrag and dragging:
		var drag_offset = event.position - drag_start_position
		
		# Определяем направление свайпа только если оно еще не определено
		if not swipe_direction_locked and initial_drag_direction == 0:
			if abs(drag_offset.x) > direction_threshold:
				initial_drag_direction = 1  # Горизонтальное
				swipe_direction_locked = true
			elif abs(drag_offset.y) > direction_threshold:
				initial_drag_direction = 2  # Вертикальное
				swipe_direction_locked = true
		
		# Обрабатываем только горизонтальные свайпы
		if initial_drag_direction == 1 or not swipe_direction_locked:
			position.x = container_start_position.x + drag_offset.x

func _check_swipe_threshold():
	# Сбрасываем блокировку направления
	swipe_direction_locked = false
	initial_drag_direction = 0
	
	var drag_distance = position.x - target_position.x
	var drag_ratio = abs(drag_distance) / size.x
	
	if drag_ratio >= swipe_threshold:
		if drag_distance < 0 and current_screen < screens.size() - 1:
			current_screen += 1
		elif drag_distance > 0 and current_screen > 0:
			current_screen -= 1
	
	target_position.x = -current_screen * (size.x + screens_margin)
	current_screen = clamp(current_screen, 0, screens.size() - 1)

func go_to_screen(index: int):
	if index >= 0 and index < screens.size():
		current_screen = index
		target_position.x = -current_screen * (size.x + screens_margin)
		can_swipe = false
		await get_tree().create_timer(0.5).timeout
		can_swipe = true

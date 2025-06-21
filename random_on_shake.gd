extends Node

const RANDOM = preload("res://random.tscn")

const RANDOM_POSITION = Vector2(540, 700)
# Порог силы встряхивания (подбирается экспериментально)
const SHAKE_THRESHOLD := 12.0
# Время между вызовами (чтобы избежать спама)
const SHAKE_COOLDOWN := 1.5

var _last_shake_time := 0.0
var _last_accel := Vector3.ZERO

var random = null


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		_on_shake()
	var current_time := Time.get_ticks_msec() / 1000.0
	
	# Получаем данные акселерометра
	var accel := Input.get_accelerometer()
	
	# Если акселерометр не активен (например, на ПК), выходим
	if accel == Vector3.ZERO:
		return
	
	# Вычисляем разницу с предыдущим кадром
	var delta_accel := accel - _last_accel
	_last_accel = accel
	
	# Игнорируем слишком частые вызовы
	if current_time - _last_shake_time < SHAKE_COOLDOWN:
		return
	
	# Проверяем силу изменения ускорения
	if delta_accel.length() > SHAKE_THRESHOLD:
		_last_shake_time = current_time
		_on_shake()

# Функция, которая вызывается при встряхивании
func _on_shake() -> void:
	if get_parent().current_random != null:
		get_parent().current_random.queue_free()
	random = RANDOM.instantiate()
	get_parent().add_child(random)
	get_parent().current_random = random
	random.global_position = RANDOM_POSITION
	var random_json = get_parent().data.values().pick_random()
	random.random_name.text = str(random_json["name"])
	var image_url = random_json["poster"]
	var new_headers = []
	var get_image_http_request = HTTPRequest.new()
	add_child(get_image_http_request)
	get_image_http_request.request_completed.connect(Callable(self, "_on_get_image_http_request_request_completed"))
	get_image_http_request.request(image_url, new_headers, HTTPClient.METHOD_GET)
	random.description.text = str(random_json["description"])


func _on_get_image_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var image = Image.new()
	image.load_jpg_from_buffer(body)
	var texture = ImageTexture.create_from_image(image)
	random.random_picture.texture = texture
	#await get_tree().create_timer(2).timeout
	random.appear()
	

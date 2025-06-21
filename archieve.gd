extends Node2D

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var texture_rect_to_copy: TextureRect = $TextureRect
@onready var grid_container: GridContainer = $ScrollContainer/GridContainer
@onready var watch_list_button: Button = $WatchListButton

const URL = "http://185.80.91.29:8000/movies/archive/?format=json"


func _ready() -> void:
	var headers = ["Content-Type: text/html"]
	http_request.request(URL, headers, HTTPClient.METHOD_GET)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	for movie_json in json.values():
		var image_url = movie_json["poster"]
		var new_headers = []
		var get_image_http_request = HTTPRequest.new()
		add_child(get_image_http_request)
		get_image_http_request.request_completed.connect(Callable(self, "_on_get_image_http_request_request_completed").bind(image_url))
		get_image_http_request.request(image_url, new_headers, HTTPClient.METHOD_GET)


func _on_get_image_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, url) -> void:
	if response_code != 200:
		var new_headers = []
		var get_image_http_request = HTTPRequest.new()
		add_child(get_image_http_request)
		get_image_http_request.request_completed.connect(Callable(self, "_on_get_image_http_request_request_completed").bind(url))
		get_image_http_request.request(url, new_headers, HTTPClient.METHOD_GET)
	else:
		var image = Image.new()
		var texture_rect = texture_rect_to_copy.duplicate()
		image.load_jpg_from_buffer(body)
		var texture = ImageTexture.create_from_image(image)
		texture_rect.texture = texture
		grid_container.add_child(texture_rect)
		grid_container.queue_sort()


func _on_watch_list_button_pressed() -> void:
	var movies_tween = create_tween()
	movies_tween.tween_property(get_parent(), "global_position", Vector2(0, 0), 0.3).set_ease(Tween.EASE_OUT)

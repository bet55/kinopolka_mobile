extends ScrollContainer

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var control: ScrollContainer = $"."
@onready var margin_container: MarginContainer = $MarginContainer
@onready var grid_container: GridContainer = $MarginContainer/GridContainer
@onready var texture_rect: TextureRect = $MarginContainer/GridContainer/TextureRect


const URL = "http://185.80.91.29:8000/movies/archive/?format=json"

var data = null
var current_random = null


func _ready() -> void:
	var headers = ["Content-Type: text/html"]
	http_request.request(URL, headers, HTTPClient.METHOD_GET)
	texture_rect.custom_minimum_size = Vector2(get_rect().size.x/3, (get_rect().size.x/3) * 1.5)
	grid_container.remove_child(texture_rect)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	data = json["data"]
	for movie_json in data.values():
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
		var movie = texture_rect.duplicate()
		grid_container.add_child(movie)
		image.load_jpg_from_buffer(body)
		var texture = ImageTexture.create_from_image(image)
		movie.texture = texture
		grid_container.queue_sort()


func _on_movies_button_pressed() -> void:
	get_tree().change_scene_to_file("res://movies.tscn")

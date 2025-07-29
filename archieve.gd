extends ScrollContainer

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var control: ScrollContainer = $"."
@onready var margin_container: MarginContainer = $MarginContainer
@onready var grid_container: GridContainer = $MarginContainer/GridContainer
#@onready var texture_rect: TextureRect = $MarginContainer/GridContainer/TextureRect
@onready var texture_rect: TextureButton = $MarginContainer/GridContainer/TextureRect


const URL = "http://185.80.91.29:8000/movies/archive/?format=json"
const MOVIE_DETAILS = preload("res://movie_details.tscn")

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
		get_image_http_request.request_completed.connect(Callable(self, "_on_get_image_http_request_request_completed").bind(image_url, movie_json))
		get_image_http_request.request(image_url, new_headers, HTTPClient.METHOD_GET)


func _on_get_image_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, url, data) -> void:
	if response_code != 200:
		var new_headers = []
		var get_image_http_request = HTTPRequest.new()
		add_child(get_image_http_request)
		get_image_http_request.request_completed.connect(Callable(self, "_on_get_image_http_request_request_completed").bind(url, data))
		get_image_http_request.request(url, new_headers, HTTPClient.METHOD_GET)
	else:
		var image = Image.new()
		var movie = texture_rect.duplicate()
		grid_container.add_child(movie)
		image.load_jpg_from_buffer(body)
		var texture = ImageTexture.create_from_image(image)
		movie.texture_normal = texture
		movie.pressed.connect(Callable(self, '_on_movie_pressed').bind(data))
		grid_container.queue_sort()


func minutes_to_hhmm(minutes_float: float) -> String:
	var total_minutes: int = int(round(minutes_float))
	var hours: int = total_minutes / 60
	var minutes: int = total_minutes % 60
	return "%02d:%02d" % [hours, minutes]


func _on_movie_pressed(data):
	var movie_genres = ''
	for genre in data['genres']:
		movie_genres += (genre + ', ')
	
	var movie_details = MOVIE_DETAILS.instantiate()
	get_parent().add_child(movie_details)
	movie_details.global_position += Vector2(get_viewport_rect().size.x, 0)
	movie_details.name_label.text = data['name']
	movie_details.premiere_label.text = data['premiere']
	movie_details.duration_label.text = minutes_to_hhmm(data['duration'])
	movie_details.genres_label.text = movie_genres
	movie_details.description_label.text = data['description']
	movie_details.rating_kp_label.text = 'КП: ' + data['rating_kp']
	movie_details.rating_imdb_label.text = 'IMDB: ' + data['rating_imdb']

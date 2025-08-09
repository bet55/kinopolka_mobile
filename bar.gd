extends ScrollContainer

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var control: ScrollContainer = $"."
@onready var margin_container: MarginContainer = $MarginContainer

#@onready var texture_rect: TextureButton = $MarginContainer/GridContainer/TextureRect
@onready var grid_container: VBoxContainer = $MarginContainer/GridContainer


const BASE_URL = "http://185.80.91.29:8000"
const URL = "http://185.80.91.29:8000/bar/cocktails"
const RECIPIE = preload("res://recipie.tscn")

var data = null
var current_random = null


func _ready() -> void:
	var headers = ["Content-Type: text/html"]
	http_request.request(URL, headers, HTTPClient.METHOD_GET)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	data = json
	for cocktail in data:
		var image_url = BASE_URL + cocktail["image"]
		var new_headers = []
		var get_image_http_request = HTTPRequest.new()
		add_child(get_image_http_request)
		get_image_http_request.request_completed.connect(Callable(self, "_on_get_image_http_request_request_completed").bind(image_url, cocktail))
		get_image_http_request.request(image_url, new_headers, HTTPClient.METHOD_GET)


func _on_get_image_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, url, cocktail) -> void:
	if response_code != 200:
		var new_headers = []
		var get_image_http_request = HTTPRequest.new()
		add_child(get_image_http_request)
		get_image_http_request.request_completed.connect(Callable(self, "_on_get_image_http_request_request_completed").bind(url, cocktail))
		get_image_http_request.request(url, new_headers, HTTPClient.METHOD_GET)
	else:
		var image = Image.new()
		var recipie = RECIPIE.instantiate()
		grid_container.add_child(recipie)
		recipie.name_label.text = cocktail['name']
		recipie.notes_label.text = cocktail['instructions']
		for ingredient in cocktail['ingredients']:
			var ingredient_box = recipie.h_box_container.duplicate()
			ingredient_box.get_children()[0].get_children()[0].text = ingredient['ingredient']['name']
			ingredient_box.get_children()[1].text = str(ingredient['amount']) + ' ' + ingredient['unit_display']
			ingredient_box.visible = true
			recipie.ingredients_v_box_container.add_child(ingredient_box)
		image.load_png_from_buffer(body)
		var texture = ImageTexture.create_from_image(image)
		recipie.texture_rect.texture = texture
		grid_container.queue_sort()

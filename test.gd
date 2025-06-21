extends Node2D

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect
@onready var get_image_http_request: HTTPRequest = $GetImageHTTPRequest

const URL = "http://185.80.91.29:8000/movies/?format=json"


func _on_button_pressed() -> void:
	var headers = ["Content-Type: text/html"]
	http_request.request(URL, headers, HTTPClient.METHOD_GET)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print(result)
	print(response_code)
	var json = JSON.parse_string(body.get_string_from_utf8())
	label.text = str(json)
	var pic_url = json["325"]["poster"]
	var new_headers = []
	get_image_http_request.request(pic_url, new_headers, HTTPClient.METHOD_GET)




func _on_get_image_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var image = Image.new()
	image.load_jpg_from_buffer(body)  # Автоматически определяет формат (Godot 4+)
		
	var texture = ImageTexture.create_from_image(image)  # Godot 4 синтаксис
	texture_rect.texture = texture

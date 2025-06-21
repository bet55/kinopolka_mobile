extends Node2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var random_picture: TextureRect = $RandomPicture
@onready var random_name: Label = $RandomName
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2
@onready var gpu_particles_2d_3: GPUParticles2D = $GPUParticles2D3
@onready var gpu_particles_2d_4: GPUParticles2D = $GPUParticles2D4
@onready var description: Label = $Description


func appear():
	gpu_particles_2d.emitting = true
	gpu_particles_2d_2.emitting = true
	gpu_particles_2d_3.emitting = true
	gpu_particles_2d_4.emitting = true
	visible = true


func _on_button_pressed() -> void:
	queue_free()

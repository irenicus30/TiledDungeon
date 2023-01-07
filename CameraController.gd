extends Node3D

const ROTATION_SPEED = .005
@onready var camera : Camera3D = $Camera


func _ready():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * ROTATION_SPEED)
		camera.rotate_x(-event.relative.y * ROTATION_SPEED)
		camera.rotation.x = clamp(camera.rotation.x, -PI/4, PI/4)

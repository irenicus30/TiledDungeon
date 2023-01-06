extends Camera3D


@export @onready var pivot_path : NodePath
var pivot : Node

const SPEED = .065

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pivot = get_node("/root/Drawing/Scene0/CameraPivot")
	print(pivot)


func _physics_process(delta):
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = ( Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#direction = direction.rotated(Vector3.UP, pivot.rotation.y)
	pivot.translate(direction * SPEED)

	var vertical_movement = 0.0
	if Input.is_action_pressed("down"):
		vertical_movement = -1.0
	elif Input.is_action_pressed("up"):
		vertical_movement = 1.0

	pivot.translate( Vector3(0, vertical_movement, 0) * SPEED )


func _unhandled_input(event):
	print(event)
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		pivot.rotate_y(-event.relative.x * .005)
		self.rotate_x(-event.relative.y * .005)
		self.rotation.x = clamp(self.rotation.x, -PI/4, PI/4)

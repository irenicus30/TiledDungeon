extends Node

@export var width = 600
@export var height = 200
@onready var tilemap = $TileMap

var temperature = {}
var moisture = {}
var altitude = {}
var biome = {}
var noise = FastNoiseLite.new()


func generate_map(per, oct):
	#noise.type = FastNoiseLite.TYPE_SIMPLEX
	noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX);
	noise.seed = randi()
	noise.domain_warp_frequency = 1.0 / per
	noise.domain_warp_fractal_octaves = oct
	
	var gridName = {}
	for x in width:
		for y in height:
			var rand : int = 5 * absf(noise.get_noise_2d(x, y))
			gridName[Vector2i(x, y)] = rand
	return gridName


func set_tile(w, h):
	for x in w:
		for y in h:
			var pos = Vector2i(x, y)
			var alt = altitude[pos]
			var temp = temperature[pos]
			var moist = moisture[pos]

			# Ocean
			if between(alt, -1.0, 1.0):
				tilemap.set_cell(0, pos, 0, Vector2i(0, 2) )
			# Beach
			elif between(alt, 1.0, 2.0):
				tilemap.set_cell(0, pos, 0, Vector2i(1, 1) )
			# Other
			elif between(alt, 2.0, 3.0):
				if between(moist, 0.0, 2.0) and between(temp, 1.0, 3.0):
					tilemap.set_cell(0, pos, 0, Vector2i(0, 0) )
				elif between(moist, 2.0, 4.0) and temp > 3.0:
					tilemap.set_cell(0, pos, 0, Vector2i(1, 0) )

func between(val, start, end):
	if start <= val and val < end:
		return true
	return false

# Called when the node enters the scene tree for the first time.
func _ready():
	temperature = generate_map(300, 5)
	moisture = generate_map(300, 5)
	altitude = generate_map(150, 5)
	
	set_tile(width, height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

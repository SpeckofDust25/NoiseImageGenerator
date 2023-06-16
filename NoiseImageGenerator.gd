extends Node

var noise_type_array: Array = [FastNoiseLite.TYPE_PERLIN, FastNoiseLite.TYPE_CELLULAR, FastNoiseLite.TYPE_SIMPLEX, 
FastNoiseLite.TYPE_SIMPLEX_SMOOTH, FastNoiseLite.TYPE_VALUE, FastNoiseLite.TYPE_VALUE_CUBIC];

#Values
@export var noise_type = FastNoiseLite.TYPE_PERLIN;
@export var width = 50;
@export var height = 50;
@export var seed: float = 0;
@export var amplitude: float = 1;
@export var frequency: float = 0.1;
@export_range(0, 1) var persistance: float = 0.1;
@export var lacunarity: float = 0.1;
@export var octaves: int = 1;
@export var x_offset: int = 0;
@export var y_offset: int = 0;
@export var inverted = false;

#Objects
var noise: FastNoiseLite
var image: Image;
var texture_rect: TextureRect;
var image_texture: ImageTexture;

# Called when the node enters the scene tree for the first time.
func _ready():
	noise = FastNoiseLite.new();
	image = Image.create(width, height, false, Image.FORMAT_RGB8);
	image_texture = ImageTexture.new();
	texture_rect = get_node("../HBoxContainer/Control/TextureRect");
	generate();

func set_noise_values(): 
	noise.set_noise_type(noise_type);
	noise.set_seed(seed);
	noise.set_frequency(frequency);
	noise.set_fractal_gain(persistance);
	noise.set_fractal_lacunarity(lacunarity);
	noise.set_fractal_octaves(octaves);

func generate_noise_image():
	for x in range(0, width):
		for y in range(0, height):
			var noise_level: float;
			
			if (inverted): 
				noise_level = ((noise.get_noise_2d(x + x_offset, y + y_offset) + 1) / 2) * amplitude;
			else: 
				noise_level = ((noise.get_noise_2d(x + x_offset, y + y_offset) + 1) / 2);
				noise_level = (1 - noise_level) * amplitude;
			
			image.set_pixelv(Vector2i(x, y), Color(noise_level, noise_level, noise_level));
	
	texture_rect.set_texture(image_texture.create_from_image(image));

func generate():
	set_noise_values();
	generate_noise_image();

#Getters
func get_noise_type()-> int:
	return FastNoiseLite.TYPE_PERLIN;

func get_width()-> float:
	return width;

func get_height()-> float:
	return height;

func get_amplitude()-> float:
	return amplitude;

func get_frequency()-> float:
	return frequency;

func get_seed()-> float:
	return seed;

func get_octaves()-> int:
	return octaves;

func get_persistance()-> float:
	return persistance;

func get_lacunarity()-> float:
	return lacunarity;

func get_x_offset()-> float:
	return x_offset;

func get_y_offset()-> float:
	return y_offset;

func get_inverted()-> bool:
	return inverted;

func get_image() -> Image:
	return image;

#Connections
func _noise_type_changed(index):
	noise_type = noise_type_array[index];
	generate();

func _width_changed(new_text):
	width = int(new_text);
	image = Image.create(width, height, false, Image.FORMAT_RGB8);
	generate();

func _height_changed(new_text):
	height = int(new_text);
	image = Image.create(width, height, false, Image.FORMAT_RGB8);
	generate();

func _seed_changed(new_text):
	seed = int(new_text);
	generate();

func _amplitude_changed(value):
	amplitude = value;
	generate();

func _frequency_changed(value):
	frequency = value;
	generate();

func _octaves_changed(value):
	octaves = value;
	generate();

func _persistance_changed(value):
	persistance = value;
	generate();

func _lacunarity_slider(value):
	lacunarity = value;
	generate();

func _x_changed(value):
	x_offset = value;
	generate();

func _y_changed(value):
	y_offset = value;
	generate();

func _inverted_changed(button_pressed):
	inverted = button_pressed;
	generate();


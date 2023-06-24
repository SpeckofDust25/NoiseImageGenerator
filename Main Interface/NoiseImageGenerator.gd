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
@export_range(0, 1) var persistence: float = 0.1;
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

#Colors
var blend_colors: bool;
var color_groups: Array;

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
	noise.set_fractal_gain(persistence);
	noise.set_fractal_lacunarity(lacunarity);
	noise.set_fractal_octaves(octaves);

func generate_noise_image():
	
	for x in range(0, width):
		for y in range(0, height):
			var previous_color: Color = Color.BLACK;
			var color: Color = Color.BLACK;
			var has_set_color: bool = false;
			var previous_value: float = 0;
			var color_value: float = 0;
			var noise_level: float = 0;
			
			#Get Noise Level
			if (inverted): #invert colors
				noise_level = (noise.get_noise_2d(x + x_offset, y + y_offset) + 1) / 2;
			else: 
				noise_level = (noise.get_noise_2d(x + x_offset, y + y_offset) + 1) / 2;
				noise_level = 1 - noise_level;
			
			#Set Default Color
			color = Color(noise_level * amplitude, noise_level * amplitude, noise_level * amplitude);
			
			#Add Color or No Color
			if (color_groups.size() > 0):
				for i in range(0, color_groups.size()):
					if (color_groups[i][1] > noise_level): #New Color
						color = color_groups[i][0];
						color_value = color_groups[i][1];
						break;
#						has_set_color = true;
#
#						if (i != 0): #Set Previous Colors
#							previous_color = color_groups[i - 1][0];
#							previous_value = color_groups[i - 1][1];
#						else:
#							previous_color = Color.BLACK;
#							previous_value = 0;
#
#						break;
				
#				if (true):  #Blend Colors
#					var value_range: float;
#					var scaled_value: float;
#
#					if (has_set_color):
#						value_range = color_value - previous_value;
#						scaled_value = ((noise_level - color_value) / value_range);
#
#						if (scaled_value > 1 or scaled_value < -1):
#							print("value range: " + str(value_range) + " scaled value: " + str(scaled_value) + " noise level: " + str(noise_level) + " color values: " + str(previous_value) + ", " + str(color_value));
#
#						print(color);
#
#						color.r = move_toward(previous_color.r, color.r, abs(scaled_value - 1));
#						color.g = move_toward(previous_color.g, color.g, abs(scaled_value - 1));
#						color.b = move_toward(previous_color.b, color.b, abs(scaled_value - 1));
#						color.a = move_toward(previous_color.a, color.a, abs(scaled_value - 1));
#
#				else:

			color = Color(color.r * noise_level, color.g * noise_level, color.b * noise_level, color.a);
			
			#color = color * amplitude;
			
			image.set_pixelv(Vector2i(x, y), color)
	
	texture_rect.set_texture(image_texture.create_from_image(image));

func generate():
	set_noise_values();
	generate_noise_image();
	get_min_max_values();

func update_colors(caller: Node):
	var color_containers: Array = caller.get_color_containers();
	color_groups.clear();
	color_groups.resize(color_containers.size());
	
	#Set all Color Node groups into a 2D array
	for i in range(0, color_groups.size()):
		color_groups[i] = [];
		color_groups[i].resize(2);
		color_groups[i][0] = color_containers[i].get_node("ColorPickerButton").get_pick_color();
		color_groups[i][1] = color_containers[i].get_node("ValueSlider").get_value();
	
	#Sort Colors
	for i in range(0, color_groups.size() - 1): #All The Loops it takes to Sort 
		for l in range(0, color_groups.size() - 1 - i):
			var temp: Array;
			
			if (color_groups[l][1] > color_groups[l + 1][1]): 
				temp = color_groups[l];
				color_groups[l] = color_groups[l + 1];
				color_groups[l + 1] = temp;
	
	# Add Colors to image after the noise values have been determined

#Getters
func get_min_max_values()-> void:
	var min = 100
	var max = -100
	
	var noise_level = 0;
	for x in range(0, 100):
		for y in range(0, 100):
			noise_level = noise.get_noise_2d(x, y);
			
			if (noise_level > max):
				max = noise_level;
			
			if (noise_level < min):
				min = noise_level;

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

func get_persistence()-> float:
	return persistence;

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

func _inverted_changed(button_pressed):
	inverted = button_pressed;
	generate();

func _update_noise(caller: Node):
	amplitude = caller.amplitude_slider.get_value();
	frequency = caller.frequency_slider.get_value();
	octaves = caller.octaves_slider.get_value();
	persistence = caller.persistence_slider.get_value();
	lacunarity = caller.lacunarity_slider.get_value();
	x_offset = caller.x_offset_slider.get_value();
	y_offset = caller.y_offset_slider.get_value();
	update_colors(caller);
	generate();

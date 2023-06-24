extends Control

signal update_noise;

#Preloads
var pre_color_container: PackedScene = preload("res://Interface Addons/color_container.tscn");

#Module Containers
var color_container_list: Array;

#Main Nodes
var noise_image_generator: Node;

#Control Interactions
var noise_type_option_button: OptionButton;
var width_line_edit: LineEdit;
var height_line_edit: LineEdit;
var seed_line_edit: LineEdit;
var amplitude_slider: HSlider;
var frequency_slider: HSlider;
var octaves_slider: HSlider;
var persistence_slider: HSlider;
var lacunarity_slider: HSlider;
var x_offset_slider: HSlider;
var y_offset_slider: HSlider;
var inverted_checkbox: CheckBox;

#Saving
var save_png_button: Button;

#Labels
var amplitude_value_label: Label;
var frequency_value_label: Label;
var octaves_value_label: Label;
var persistence_value_label: Label;
var lacunarity_value_label: Label;
var x_offset_value_label: Label;
var y_offset_value_label: Label;

#Colors Tab
var color_list_main_container: VBoxContainer;

#Initialize
func _ready():
	var properties = get_node("HBoxContainer/TabContainer/Properties");
	noise_image_generator = get_node("NoiseImageGenerator");
	noise_type_option_button = properties.get_node("HBoxContainer/VBoxContainer/NoiseTypeContainer/NoiseTypeOptionButton");
	width_line_edit = properties.get_node("HBoxContainer/VBoxContainer/WidthContainer/WidthLineEdit");
	height_line_edit = properties.get_node("HBoxContainer/VBoxContainer/HeightContainer/HeightLineEdit");
	seed_line_edit = properties.get_node("HBoxContainer/VBoxContainer/SeedContainer/SeedLineEdit");
	amplitude_slider = properties.get_node("HBoxContainer/VBoxContainer/AmplitudeContainer/AmplitudeSlider");
	frequency_slider = properties.get_node("HBoxContainer/VBoxContainer/FrequencyContainer/FrequencySlider");
	octaves_slider = properties.get_node("HBoxContainer/VBoxContainer/OctavesContainer/OctavesSlider");
	persistence_slider = properties.get_node("HBoxContainer/VBoxContainer/PersistenceContainer/PersistenceSlider");
	lacunarity_slider = properties.get_node("HBoxContainer/VBoxContainer/LacunarityContainer/LacunaritySlider");
	x_offset_slider = properties.get_node("HBoxContainer/VBoxContainer/OffsetContainer/XSlider");
	y_offset_slider = properties.get_node("HBoxContainer/VBoxContainer/OffsetContainer/YSlider");
	inverted_checkbox = properties.get_node("HBoxContainer/VBoxContainer/InvertedContainer/InvertedCheckBox");
	
	amplitude_value_label = properties.get_node("HBoxContainer/VBoxContainer/AmplitudeContainer/AmplitudeValueLabel");
	frequency_value_label = properties.get_node("HBoxContainer/VBoxContainer/FrequencyContainer/FrequencyValueLabel");
	octaves_value_label = properties.get_node("HBoxContainer/VBoxContainer/OctavesContainer/OctavesValueLabel");
	persistence_value_label = properties.get_node("HBoxContainer/VBoxContainer/PersistenceContainer/PersistenceValueLabel");
	lacunarity_value_label = properties.get_node("HBoxContainer/VBoxContainer/LacunarityContainer/LacunarityValueLabel");
	x_offset_value_label = properties.get_node("HBoxContainer/VBoxContainer/OffsetContainer/XOffsetValueLabel");
	y_offset_value_label = properties.get_node("HBoxContainer/VBoxContainer/OffsetContainer/YOffsetValueLabel");
	
	save_png_button = properties.get_node("HBoxContainer/VBoxContainer/SavePngContainer/SavePngButton")
	
	width_line_edit.text = str(noise_image_generator.get_width());
	height_line_edit.text = str(noise_image_generator.get_height());
	seed_line_edit.text = str(noise_image_generator.get_seed());
	amplitude_slider.value = noise_image_generator.get_amplitude();
	frequency_slider.value = noise_image_generator.get_frequency();
	octaves_slider.value = noise_image_generator.get_octaves();
	persistence_slider.value = noise_image_generator.get_persistence();
	lacunarity_slider.value = noise_image_generator.get_lacunarity();
	x_offset_slider.value = noise_image_generator.get_x_offset();
	y_offset_slider.value = noise_image_generator.get_y_offset();
	inverted_checkbox.button_pressed = noise_image_generator.get_inverted();
	
	#Color Tab
	color_list_main_container = get_node("HBoxContainer/TabContainer/Color/VBoxContainer/ColorInterfaceContainer/ColorListContainer");

func _process(delta):
	#Color Tab: Update Colors
	if (color_container_list.size() > 0):
		for i in range(0, color_container_list.size()):
			if (color_container_list[i] == null):
				color_container_list.remove_at(i);
				break;
		
		for i in color_container_list:
			if (i.has_node("ColorPickerButton") and i.has_node("ValueSlider")):
				var color: Color = i.get_node("ColorPickerButton").get_pick_color();
				var value: float = i.get_node("ValueSlider").get_value();

#Getters
func get_color_containers() -> Array:
	return color_container_list;

#Properties Tab Connections
func _amplitude_changed(value):
	amplitude_value_label.set_text(str(value));
	emit_signal("update_noise", self);

func _frequency_changed(value):
	frequency_value_label.set_text(str("%.2f" % value));
	emit_signal("update_noise", self);

func _octaves_changed(value):
	octaves_value_label.set_text(str(value));
	
	if (value > 1):
		lacunarity_slider.set_editable(true);
		persistence_slider.set_editable(true);
	else:
		lacunarity_slider.set_editable(false);
		persistence_slider.set_editable(false);
	
	emit_signal("update_noise", self);

func _persistence_changed(value):
	persistence_value_label.set_text(str(value));
	emit_signal("update_noise", self);

func _lacunarity_changed(value):
	lacunarity_value_label.set_text(str(value));
	emit_signal("update_noise", self);

func _x_offset_changed(value):
	x_offset_value_label.set_text(str(value));
	emit_signal("update_noise", self);

func _y_offset_changed(value):
	y_offset_value_label.set_text(str(value));
	emit_signal("update_noise", self);

func _save_button_pressed():
	if (noise_image_generator.has_method("get_image")):
		var image: Image = noise_image_generator.get_image();
		var save_path: String = "";
		
		if (OS.has_feature("editor")):
			save_path = "res://Images/" + Time.get_datetime_string_from_system(false, false).replace(":", "_") + ".png";
			if (!DirAccess.dir_exists_absolute("res://Images")):
				DirAccess.make_dir_absolute("res://Images");
		else:
			save_path = OS.get_executable_path().get_base_dir() + "/Images/" + Time.get_datetime_string_from_system(false, false).replace(":", "_") + ".png";
			
			if (!DirAccess.dir_exists_absolute(OS.get_executable_path().get_base_dir() + "/Images")):
				DirAccess.make_dir_absolute(OS.get_executable_path().get_base_dir() + "/Images");
		
		image.save_png(save_path);

#Color Tab Connnections
func _add_color_container():
	var color_container = pre_color_container.instantiate();
	color_list_main_container.add_child(color_container);
	
	#Connect to Signals
	if (color_container.has_node("ColorPickerButton") and color_container.has_node("ValueSlider")):
		color_container.get_node("ValueSlider").connect("value_changed", _color_value_changed);
		color_container.get_node("ColorPickerButton").connect("color_changed", _color_changed);
		color_container.get_node("DeleteButton").connect("tree_exited", _delete_button);
	else:
		print_debug("Can't Find ColorPickerButton and ValueSlider Nodes");
	
	color_container_list.push_back(color_container);

func _delete_button(): 
	emit_signal("update_noise", self);

func _color_changed(color: Color):
	emit_signal("update_noise", self);

func _color_value_changed(value: float):
	emit_signal("update_noise", self);

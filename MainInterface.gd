extends Control

var heightmap_image_generator: Node;

#Control Interactions
var noise_type_option_button: OptionButton;
var width_line_edit: LineEdit;
var height_line_edit: LineEdit;
var seed_line_edit: LineEdit;
var amplitude_slider: HSlider;
var frequency_slider: HSlider;
var octaves_slider: HSlider;
var persistance_slider: HSlider;
var lacunarity_slider: HSlider;
var x_offset_slider: HSlider;
var y_offset_slider: HSlider;
var inverted_checkbox: CheckBox;

#Labels
var amplitude_value_label: Label;
var frequency_value_label: Label;
var octaves_value_label: Label;
var persistance_value_label: Label;
var lacunarity_value_label: Label;
var x_offset_value_label: Label;
var y_offset_value_label: Label;

#Initialize
func _ready():
	var properties = get_node("HBoxContainer/TabContainer/Properties");
	heightmap_image_generator = get_node("HeightmapImageGenerator");
	noise_type_option_button = properties.get_node("HBoxContainer/VBoxContainer/NoiseTypeContainer/NoiseTypeOptionButton");
	width_line_edit = properties.get_node("HBoxContainer/VBoxContainer/WidthContainer/WidthLineEdit");
	height_line_edit = properties.get_node("HBoxContainer/VBoxContainer/HeightContainer/HeightLineEdit");
	seed_line_edit = properties.get_node("HBoxContainer/VBoxContainer/SeedContainer/SeedLineEdit");
	amplitude_slider = properties.get_node("HBoxContainer/VBoxContainer/AmplitudeContainer/AmplitudeSlider");
	frequency_slider = properties.get_node("HBoxContainer/VBoxContainer/FrequencyContainer/FrequencySlider");
	octaves_slider = properties.get_node("HBoxContainer/VBoxContainer/OctavesContainer/OctavesSlider");
	persistance_slider = properties.get_node("HBoxContainer/VBoxContainer/PersistanceContainer/PersistanceSlider");
	lacunarity_slider = properties.get_node("HBoxContainer/VBoxContainer/LacunarityContainer/LacunaritySlider");
	x_offset_slider = properties.get_node("HBoxContainer/VBoxContainer/OffsetContainer/XSlider");
	y_offset_slider = properties.get_node("HBoxContainer/VBoxContainer/OffsetContainer/YSlider");
	inverted_checkbox = properties.get_node("HBoxContainer/VBoxContainer/InvertedContainer/InvertedCheckBox");
	
	amplitude_value_label = properties.get_node("HBoxContainer/VBoxContainer/AmplitudeContainer/AmplitudeValueLabel");
	frequency_value_label = properties.get_node("HBoxContainer/VBoxContainer/FrequencyContainer/FrequencyValueLabel");
	octaves_value_label = properties.get_node("HBoxContainer/VBoxContainer/OctavesContainer/OctavesValueLabel");
	persistance_value_label = properties.get_node("HBoxContainer/VBoxContainer/PersistanceContainer/PersistanceValueLabel");
	lacunarity_value_label = properties.get_node("HBoxContainer/VBoxContainer/LacunarityContainer/LacunarityValueLabel");
	x_offset_value_label = properties.get_node("HBoxContainer/VBoxContainer/OffsetContainer/XOffsetValueLabel");
	y_offset_value_label = properties.get_node("HBoxContainer/VBoxContainer/OffsetContainer/YOffsetValueLabel");
	
	width_line_edit.text = str(heightmap_image_generator.get_width());
	height_line_edit.text = str(heightmap_image_generator.get_height());
	seed_line_edit.text = str(heightmap_image_generator.get_seed());
	amplitude_slider.value = heightmap_image_generator.get_amplitude();
	frequency_slider.value = heightmap_image_generator.get_frequency();
	octaves_slider.value = heightmap_image_generator.get_octaves();
	persistance_slider.value = heightmap_image_generator.get_persistance();
	lacunarity_slider.value = heightmap_image_generator.get_lacunarity();
	x_offset_slider.value = heightmap_image_generator.get_x_offset();
	y_offset_slider.value = heightmap_image_generator.get_y_offset();
	inverted_checkbox.button_pressed = heightmap_image_generator.get_inverted();

#Connections
func _amplitude_changed(value):
	amplitude_value_label.set_text(str(value));

func _frequency_changed(value):
	frequency_value_label.set_text(str("%.2f" % value));

func _octaves_changed(value):
	octaves_value_label.set_text(str(value));
	
	if (value > 1):
		lacunarity_slider.set_editable(true);
		persistance_slider.set_editable(true);
	else:
		lacunarity_slider.set_editable(false);
		persistance_slider.set_editable(false);

func _persistance_changed(value):
	persistance_value_label.set_text(str(value));

func _lacunarity_changed(value):
	lacunarity_value_label.set_text(str(value));

func _x_offset_changed(value):
	x_offset_value_label.set_text(str(value));

func _y_offset_changed(value):
	y_offset_value_label.set_text(str(value));

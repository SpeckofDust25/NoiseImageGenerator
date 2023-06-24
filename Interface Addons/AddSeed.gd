extends HBoxContainer

var line_edit: LineEdit;

func _ready():
	line_edit = get_node("SeedLineEdit");

func _on_add_seed_pressed():
	line_edit.set_text(str(int(line_edit.get_text()) + 1));
	line_edit.emit_signal("text_changed", line_edit.get_text());

func _on_subtract_seed_pressed():
		line_edit.set_text(str(int(line_edit.get_text()) - 1));
		line_edit.emit_signal("text_changed", line_edit.get_text());

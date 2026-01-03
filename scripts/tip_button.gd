class_name TipButton
extends Button

var tip_text: String:
	get:
		return tip_label.text
	set(value):
		tip_label.text = value

@onready var tip_popup: PopupPanel = $TipPopup
@onready var tip_label: Label = $TipPopup/TipLabel


func _ready() -> void:
	pressed.connect(
		func() -> void:
			tip_popup.position = global_position
			tip_popup.size = tip_label.get_combined_minimum_size()
			tip_popup.show()
	)

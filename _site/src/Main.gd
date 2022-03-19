extends Control

# Header
onready var title : Label = self.get_node("Container/Header/Title")
onready var switcher : CheckButton = self.get_node("Container/Header/Container/CheckButton")

# Description
onready var description : RichTextLabel = self.get_node("Container/Content/Description")

# Seed
onready var seed_button : Button = self.get_node("Container/Content/Seed/Button")
onready var current_seed : SpinBox = self.get_node("Container/Content/Seed/Seed")

# Highest Lot Number
onready var highest_lot_number_label : Label = self.get_node("Container/Content/Highest Lot Number/Label")
onready var highest_number_1 : SpinBox = self.get_node("Container/Content/Highest Lot Number/Number 1")
onready var highest_number_2 : SpinBox = self.get_node("Container/Content/Highest Lot Number/Number 2")
onready var highest_number_3 : SpinBox = self.get_node("Container/Content/Highest Lot Number/Number 3")
onready var highest_number_4 : SpinBox = self.get_node("Container/Content/Highest Lot Number/Number 4")

# Generate
onready var generate_button : Button = self.get_node("Container/Content/Button")

# Result
onready var result_label : Label = self.get_node("Container/Content/Result/Label")
onready var result : Label = self.get_node("Container/Content/Result/Result")

# Footer
onready var footer : Label = self.get_node("Container/Footer/Label")

var language : String = "de" setget set_language
var random : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	if self.language == "de":
		self.switcher.pressed = true
		self.set_language("de")
	else:
		self.switcher.pressed = false
		self.set_language("en")
	
	var _error : int
	_error = self.current_seed.connect("value_changed", self, "_on_seed_changed")
	_error = self.switcher.connect("pressed", self, "_on_switcher_pressed", [self.switcher])
	_error = self.seed_button.connect("pressed", self, "_on_seed_pressed")
	_error = self.generate_button.connect("pressed", self, "_on_generate_pressed")

func set_language(value : String) -> void:
	language = value
	
	var _error : int
	var file : File = File.new()
	if language == "de":
		_error = file.open("res://de.json", File.READ)
	else:
		_error = file.open("res://en.json", File.READ)
		
	var json : String = file.get_as_text()
	var json_result : Dictionary = JSON.parse(json).result
	file.close()
	
	# Set title
	self.title.text = json_result["title"]
	
	# Set description
	var lines = json_result["description"]
	
	var text = ""
	for line in lines:
		text += line + "\n\n"
	self.description.text = text
	
	self.seed_button.text = json_result["seed_button"]
	self.highest_lot_number_label.text = json_result["highest_lot_number"]
	self.generate_button.text = json_result["generate"]
	self.result_label.text = json_result["lot_number"]
	self.footer.text = json_result["footer"]

func _on_switcher_pressed(button : CheckButton) -> void:
	if button.pressed:
		self.language = "de"
	else:
		self.language = "en"

func _on_seed_changed(_value) -> void:
	# Assing seed
	self.random.seed = int(self.current_seed.value)

func _on_seed_pressed() -> void:
	
	# Randomize
	self.random.randomize()
	
	# Create random seed
	self.current_seed.value = self.random.randi()

func _on_generate_pressed() -> void:
	
	# Get first number
	var max_1 : int = int(self.highest_number_1.value)
	var number_1 : int = self.random.randi_range(1, max_1)
	
	# Get second number
	var max_2 : int = int(self.highest_number_2.value) if number_1 == max_1 else 36
	var number_2 : int = self.random.randi_range(1, max_2)
	
	# Get third number
	var max_3 : int = int(self.highest_number_3.value) if number_2 == max_2 else 36
	var number_3 : int = self.random.randi_range(1, max_3)
	
	# Get fourth number
	var max_4 : int = int(self.highest_number_4.value) if number_3 == max_3 else 36
	var number_4 : int = self.random.randi_range(1, max_4)
	
	# Print Number
	self.result.text = str(number_1) + " | " + str(number_2) + " | " + str(number_3) + " | " + str(number_4)

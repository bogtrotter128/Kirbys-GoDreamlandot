extends Node
@onready var timer = $"UI elements/timer UI"
var time = 120.0 #every 1 is a second, every 60 is a minute

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start_timer(time, false)

extends Node2D
@onready var main = $".."
@export var Ypaddles = false
@export var stagescore = 00
@export var xbounds = [-84,84]
@export var ybounds = [-30,38]

func _ready():
	main.xbounds = xbounds
	main.ybounds = ybounds
	main.updatepaddles(Ypaddles)
	main.stagescore = stagescore

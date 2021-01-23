extends CanvasLayer

const HEART_SIZE = 15

var hearts = 4 setget setHearts
var maxHearts = 4 setget setMaxHearts

onready var label : Label = $Label
onready var heartsEmpty : TextureRect = $PixelHearts/HeartsEmpty
onready var heartsFull : TextureRect = $PixelHearts/HeartsFull

func _ready():
	self.maxHearts = PlayerStats.maxHealth
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "setHearts")
	PlayerStats.connect("max_health_Changed", self, "setMaxHearts")

# Setters
func setHearts(value : int):
	print(value)
	hearts = clamp( value , 0 , maxHearts )
	heartsFull.rect_size.x = value * HEART_SIZE

func setMaxHearts(value: int):
	maxHearts = max(value, 1)
	heartsEmpty.rect_size.x = maxHearts * HEART_SIZE

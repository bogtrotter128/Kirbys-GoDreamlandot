extends ParallaxBackground

func _process(delta):
	scroll_offset.x -= 100 * delta
	scroll_offset.y += 100 * delta

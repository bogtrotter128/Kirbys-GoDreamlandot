extends VisibleOnScreenNotifier2D
var call = false
func _ready():
	set_process(false)
	await get_tree().create_timer(0.5).timeout
	set_process(true)

func _on_screen_exited():
	call = true
	if GameUtils.RECALL == false:
		GameUtils.RECALL = true
		recall()

func _on_screen_entered():
	call = false

func _process(_delta):
	if call == true && GameUtils.RECALL == false:
		GameUtils.RECALL = true
		call = false
		recall()

func recall():
	if $"..".is_in_group("player1"):
		GameUtils.firstplayerrecall = true
	if $"..".is_in_group("player2"):
		GameUtils.secondplayerrecall = true
	$"..".queue_free()

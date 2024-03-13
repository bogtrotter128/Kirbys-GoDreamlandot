extends Node

func play_sfx(sound: AudioStream, parent: Node):
	if sound != null and parent != null:
		var stream_player = AudioStreamPlayer.new()
		stream_player.stream = sound
		stream_player.connect("finished", Callable(stream_player, "queue_free"))
		parent.add_child(stream_player)
		stream_player.play()

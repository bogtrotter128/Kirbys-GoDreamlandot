extends CanvasLayer

var updatehpv = false
var updatehpv2 = false
func updatehp():
	if GameUtils.MAXHP < 9999:
		updatehpv = true
func updatehp2():
	if GameUtils.MAXHPP2 < 9999:
		updatehpv2 = true

var upability = false
var upability2 = false
func updateability():
	upability = true
func updateability2():
	upability2 = true

var starbarup = false
func updatestarbar():
	starbarup = true

var score1up = false
func updatescore1up():
	score1up = true

var upenemybar = false
func updateenemybar():
	upenemybar = true


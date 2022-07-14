extends Node2D

signal unlock(level)

const UNLOCK_THRESHOLD := 10

var _dead_enemies := 0
var _unlocks := 0


func _on_Enemy_dead()->void:
	if _unlocks < 3:
		_dead_enemies += 1
		if _dead_enemies >= UNLOCK_THRESHOLD * (_unlocks + 1):
			_unlocks += 1
			emit_signal("unlock", _unlocks)


func _on_Player_combo(combo_name:String)->void:
	print("combo_name")

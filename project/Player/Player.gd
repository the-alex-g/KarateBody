class_name Player
extends Node2D

signal combo(combo_name)

enum Side {LEFT, RIGHT}

onready var _punch_delay_timer = $PunchDelayTimer as Timer
onready var _combo_reset_timer = $ComboResetTimer as Timer
onready var _tween = $Tween as Tween
onready var area = $HitArea as Area2D

export var punch_delay_time := 0.5

var side = null
var can_punch := true
var damage := 1
var back_flip_neck_stomp := false
var double_jump_front_kick := false
var thunder_foot := false
var power_hands := false
var tiger_claw_bat_fist := false
var _a_combo := 0
var _b_combo := 0
var _y_combo := 0

func _ready()->void:
	_punch_delay_timer.wait_time = punch_delay_time


func _input(_event)->void:
	if Input.is_action_just_pressed("go_left") and side != Side.LEFT:
		_go_left()
	if Input.is_action_just_pressed("go_right") and side != Side.RIGHT:
		_go_right()
	if Input.is_action_just_pressed("punch") and can_punch:
		_punch()
	if Input.is_action_just_pressed("a"):
		_a_combo += 1
		_combo_reset_timer.stop()
		_combo_reset_timer.start()
	if Input.is_action_just_pressed("b"):
		_b_combo += 1
		_combo_reset_timer.stop()
		_combo_reset_timer.start()
	if Input.is_action_just_pressed("y"):
		_y_combo += 1
		_combo_reset_timer.stop()
		_combo_reset_timer.start()


func _go_left()->void:
	side = Side.LEFT
	_interpolate("position", Vector2(200, 500), 0.5, Tween.TRANS_QUAD)


func _go_right()->void:
	side = Side.RIGHT
	_interpolate("position", Vector2(400, 500), 0.5, Tween.TRANS_QUAD)


func _punch()->void:
	can_punch = false
	var modifiers := _check_for_combo()
	_punch_delay_timer.start(punch_delay_time * modifiers["reload"])
	emit_signal("combo", modifiers["combo_name"])
	_hit_check(damage + modifiers["damage"], modifiers["throwback"])


func _check_for_combo()->Dictionary:
	var modifiers := {"reload":0, "damage":0, "throwback":0, "combo_name":""}
	if _a_combo == 1 and _b_combo == 1 and _y_combo == 1 and thunder_foot:
		modifiers["combo_name"] = "thunder foot"
		modifiers["damage"] = 3
		modifiers["throwback"] = 100
	elif _y_combo == 1 and _b_combo == 1 and back_flip_neck_stomp:
		modifiers["combo_name"] = "back flip neck stomp"
		modifiers["damage"] = 3
		modifiers["reload"] = 1.8
	elif _a_combo == 2 and double_jump_front_kick:
		modifiers["combo_name"] = "double jump front kick"
		modifiers["damage"] = 2
		modifiers["throwback"] = 50
		modifiers["reload"] = 1.5
	elif _a_combo == 1 and tiger_claw_bat_fist:
		modifiers["combo_name"] = "tiger claw bat fist"
		modifiers["damage"] = 1
		modifiers["throwback"] = 50
		modifiers["reload"] = 1.5
	elif _b_combo == 1 and power_hands:
		modifiers["combo_name"] = "power hands"
		modifiers["damage"] = 1
	return modifiers


func _hit_check(damage_dealt:int, additional_throwback:int)->void:
	for body in area.get_overlapping_bodies():
		body.hit(damage_dealt, additional_throwback)


func _draw()->void:
	draw_rect(Rect2(Vector2(-10,-20), Vector2(20,40)), Color(0,0.8,1))


func _on_PunchDelayTimer_timeout()->void:
	can_punch = true


func _interpolate(property:String, to, duration:float, transition_type:int)->void:
	_tween.interpolate_property(self, property, null, to, duration, transition_type)
	_tween.start()


func _on_Main_unlock(level:int)->void:
	match level:
		1:
			tiger_claw_bat_fist = true
			power_hands = true
		2:
			back_flip_neck_stomp = true
			double_jump_front_kick = true
		3:
			thunder_foot = true


func _on_ComboResetTimer_timeout()->void:
	_a_combo = 0
	_b_combo = 0
	_y_combo = 0

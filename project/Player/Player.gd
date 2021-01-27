extends Node2D

enum Side {LEFT, RIGHT}

onready var _punchdelaytimer := $PunchDelayTimer
onready var _tween := $Tween
onready var area := $HitArea

export var punch_delay_time := 0.5

var _error
var side = Side.LEFT
var can_punch := true

# warning-ignore:unused_signal
signal hit_left
# warning-ignore:unused_signal
signal hit_right

func _ready():
	_punchdelaytimer.wait_time = punch_delay_time

func _process(_delta):
	if Input.is_action_just_pressed("go_left") and side != Side.LEFT:
		go_left()
	if Input.is_action_just_pressed("go_right") and side != Side.RIGHT:
		go_right()
	if Input.is_action_just_pressed("punch") and can_punch:
		punch()

func go_left():
	side = Side.LEFT
	_tween.interpolate_property(self, "position", null, Vector2(200,500), 0.4)
	_tween.start()

func go_right():
	side = Side.RIGHT
	_tween.interpolate_property(self, "position", null, Vector2(400, 500), 0.4)
	_tween.start()

func punch():
	can_punch = false
	_punchdelaytimer.start()
	match side:
		Side.LEFT:
			hit_check("left")
		Side.RIGHT:
			hit_check("right")

func hit_check(side_to_check:String):
	for body in area.get_overlapping_bodies():
		emit_signal("hit_"+side_to_check)
		body.hit()

func _draw():
	draw_rect(Rect2(Vector2(-10,-20), Vector2(20,40)), Color(0,0.8,1))

func _on_PunchDelayTimer_timeout():
	can_punch = true

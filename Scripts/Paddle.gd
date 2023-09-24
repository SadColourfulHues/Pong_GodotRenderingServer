class_name PaddleEntity
extends Entity

const MAX_ACCEL := 64.0
const SPEED := 50.0 * Constants.RENDER_SCALE

var is_player: bool
var y_accel: float

var ball_y: float
var time: float


func _init(owner: RID, texture: Texture, player: bool) -> void:
	var texture_idx := 0 if player else 1
	super._init(owner, texture, texture_idx, Constants.TAG_PADDLE)

	self.is_player = player
	self.y_accel = 0.0

	# Default paddle position: centred horizontally at extreme edges, with a padding of 4
	if is_player:
		set_position(Vector2(4 * Constants.RENDER_SCALE, (Constants.SCREEN_HEIGHT / 2) - (4 * Constants.RENDER_SCALE)))
	else:
		ball_y = (Constants.SCREEN_HEIGHT / 2) - (4 * Constants.RENDER_SCALE)
		set_position(Vector2(Constants.SCREEN_WIDTH - (12 * Constants.RENDER_SCALE), (Constants.SCREEN_HEIGHT / 2) - (4 * Constants.RENDER_SCALE)))


func set_target(y: float) -> void:
	var dy = 0.8 * (y - ball_y)

	# Make the computer sometimes under/overshoot their prediction
	var prediction = ball_y + dy * (lerp(-0.66, 1.55, randf()) * 32.0)
	ball_y = lerp(ball_y, y * 0.8 + prediction * 0.2, 0.1)


func get_normal() -> Vector2:
	return Vector2.RIGHT if is_player else Vector2.LEFT


## Events ##


func _input(event: InputEvent) -> void:
	if !is_player:
		return

	if !(event is InputEventMouseMotion):
		return

	event = event as InputEventMouseMotion
	__set_accel(event.relative.y)


func _update(delta: float) -> void:
	if abs(y_accel) > 0.0:
		var y := transform.origin.y

		y += y_accel * delta * SPEED
		y = clamp(y, 4 * Constants.RENDER_SCALE, Constants.SCREEN_HEIGHT - (4 * Constants.RENDER_SCALE))

		set_position(Vector2(transform.origin.x, y))
		y_accel = lerp(y_accel, 0.0, 0.05)

	if is_player:
		return

	time += 5.0 * delta
	__handle_computer_input()


## Helpers ##


func __set_accel(step: float) -> void:
	y_accel = lerp(y_accel, clamp(step, -MAX_ACCEL, MAX_ACCEL), 0.09)


## Handlers ##


func __handle_computer_input() -> void:
	__set_accel(ball_y - transform.origin.y)

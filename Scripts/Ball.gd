class_name BallEntity
extends Entity

const SPEED := 80.0

signal on_score(player_scored: bool)

var velocity: Vector2
var speed: float


func _init(owner: RID, texture: Texture2D) -> void:
	super._init(owner, texture, 2)
	self.tag = Constants.TAG_BALL

	__reset()


func _update(delta: float) -> void:
	if __has_left_board():
		__reset()
		return

	__handle_vertical_edge_bounce()
	__handle_motion(delta)


## Helpers ##


func bounce_velocity(normal: Vector2) -> void:
	velocity = velocity.bounce(normal)

	# Prevent the bounce angle from being too straight
	var abs_y_velocity: float = abs(velocity.y)

	if abs_y_velocity < 0.15 || abs_y_velocity > 0.9:
		velocity.y = clamp(abs(velocity.y), 0.15, 0.9) * sign(velocity.y)
		velocity = velocity.normalized()

	set_position(transform.origin + velocity)


func __reset() -> void:
	set_position(Vector2((Constants.SCREEN_WIDTH / 2) - (4 * Constants.RENDER_SCALE), (Constants.SCREEN_HEIGHT / 2) - (4 * Constants.RENDER_SCALE)))

	velocity.x = -1.0 if randf() < 0.5 else 1.0
	velocity.y = 0.33 + (randf() * 0.55) * (-1.0 + randf() * 2.0)
	velocity = velocity.normalized()

	speed = SPEED * (lerp(0.8, 1.35, randf()))


func __has_left_board() -> bool:
	var x := transform.origin.x

	if x < 4:
		on_score.emit(false)
		return true
	elif x > (Constants.SCREEN_WIDTH - 8):
		on_score.emit(true)
		return true

	return false


## Handlers ##


func __handle_motion(delta: float) -> void:
	var next_position := transform.origin
	next_position += velocity * (speed * Constants.RENDER_SCALE) * delta

	next_position.y = clamp(next_position.y, 4 * Constants.RENDER_SCALE, Constants.SCREEN_HEIGHT - 4)
	set_position(next_position)


func __handle_vertical_edge_bounce() -> void:
	var y := transform.origin.y

	if y <= (4 * Constants.RENDER_SCALE):
		bounce_velocity(Vector2.DOWN)
	elif y >= Constants.SCREEN_HEIGHT - (4 * Constants.RENDER_SCALE):
		bounce_velocity(Vector2.UP)

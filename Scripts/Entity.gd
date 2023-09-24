class_name Entity
extends Drawable

const ENTITY_SIZE := Vector2(6, 6) * Constants.RENDER_SCALE
var tag: StringName


func _init(owner: RID, texture: Texture2D, texture_idx: int, tag: StringName = Constants.TAG_DEFAULT) -> void:
	super._init(owner, texture, texture_idx)
	self.tag = tag


## Events ##


func _input(_event: InputEvent) -> void:
	pass


func _update(_delta: float) -> void:
	pass


## Helpers ##

func is_touching(other: Entity) -> bool:
	var rect := Rect2(transform.origin, ENTITY_SIZE)
	var other_rect := Rect2(other.transform.origin, ENTITY_SIZE)

	return rect.intersects(other_rect)


func GET_AWAY_FROM(other: Entity) -> void:
	var away = (transform.origin - other.transform.origin).normalized()
	transform.origin += away * 1.15

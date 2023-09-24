class_name Drawable
extends RefCounted

var rid: RID
var transform: Transform2D


func _init(owner: RID, texture: Texture2D, texture_idx: int) -> void:
	var src_rect := Rect2(texture_idx * 8, 0, 8, 8)
	var dst_rect := Rect2(0, 0, 8, 8)

	# Configure sprite
	self.rid = RenderingServer.canvas_item_create()

	RenderingServer.canvas_item_set_parent(rid, owner)
	RenderingServer.canvas_item_add_texture_rect_region(rid, dst_rect, texture, src_rect)
	RenderingServer.canvas_item_set_default_texture_filter(rid, RenderingServer.CANVAS_ITEM_TEXTURE_FILTER_NEAREST)

	set_position(Vector2.ZERO)


func _notification(what: int) -> void:
	if what != NOTIFICATION_PREDELETE:
		return

	# Remove the sprite before the drawable is freed
	RenderingServer.free_rid(rid)


## Helpers ##


func set_position(position: Vector2) -> void:
	transform.origin = position
	RenderingServer.canvas_item_set_transform(rid, transform.scaled_local(Vector2(Constants.RENDER_SCALE, Constants.RENDER_SCALE)))


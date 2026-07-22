class_name NormalTileMapLayer
extends EditorTileMapLayer

func _redraw_cell(coords: Vector2i) -> void:
	var source_id: Variant = data.get_cell(layer, coords)

	if source_id == null:
		erase_cell(coords)
	else:
		set_cell(coords, source_id, Vector2i.ZERO)

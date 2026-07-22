class_name DualGridTileMapLayer
extends EditorTileMapLayer

@export var source_id: int = 0

const MASK_TO_ATLAS: Dictionary[int, Vector2i] = {
	0b0001: Vector2i(1, 3),
	0b0010: Vector2i(0, 0),
	0b0011: Vector2i(3, 0),
	0b0100: Vector2i(0, 2),
	0b0101: Vector2i(1, 0),
	0b0110: Vector2i(2, 3),
	0b0111: Vector2i(1, 1),
	0b1000: Vector2i(3, 3),
	0b1001: Vector2i(0, 1),
	0b1010: Vector2i(3, 2),
	0b1011: Vector2i(2, 0),
	0b1100: Vector2i(1, 2),
	0b1101: Vector2i(2, 2),
	0b1110: Vector2i(3, 1),
	0b1111: Vector2i(2, 1),
}

const _CORNERS: Array[Vector2i] = [
	Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1),
]

func _ready() -> void:
	position = -Vector2(tile_set.tile_size) / 2.0
	super()

func _redraw_cell(coords: Vector2i) -> void:
	for corner: Vector2i in _CORNERS:
		_update_tile(coords + corner)

func _update_tile(tile_coords: Vector2i) -> void:
	var mask: int = 0

	if _is_filled(tile_coords - Vector2i(1, 1)):
		mask |= 0b1000
	if _is_filled(tile_coords - Vector2i(0, 1)):
		mask |= 0b0100
	if _is_filled(tile_coords - Vector2i(1, 0)):
		mask |= 0b0010
	if _is_filled(tile_coords):
		mask |= 0b0001

	if mask == 0:
		erase_cell(tile_coords)
	else:
		set_cell(tile_coords, source_id, MASK_TO_ATLAS[mask])

func _is_filled(coords: Vector2i) -> bool:
	return data.get_cell(layer, coords) == source_id

class_name File

const FILE_PATH: String = "user://levels/level_%d.dat"

static func save(data: Data, level: int) -> Error:
	var path: String = FILE_PATH % level
	DirAccess.make_dir_recursive_absolute(path.get_base_dir())

	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)

	if file == null:
		return FileAccess.get_open_error()

	file.store_var(data.to_dict())
	return OK

static func load(data: Data, level: int) -> Error:
	var file: FileAccess = FileAccess.open(FILE_PATH % level, FileAccess.READ)

	if file == null:
		return FileAccess.get_open_error()

	var loaded: Variant = file.get_var()

	if loaded is not Dictionary:
		return ERR_FILE_CORRUPT

	data.from_dict(loaded)
	return OK

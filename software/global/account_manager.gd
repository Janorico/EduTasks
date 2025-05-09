extends Node

signal accounts_loaded
const ACCOUNTS_DIR := "user://accounts"
var accounts: Array[Account] = []
var are_accounts_loaded := false


func _enter_tree() -> void:
	if !DirAccess.dir_exists_absolute(ACCOUNTS_DIR):
		DirAccess.make_dir_absolute(ACCOUNTS_DIR)
	var dir = DirAccess.open(ACCOUNTS_DIR)
	if dir == null:
		OS.crash("Couldn't access account dir with code '%s'." % DirAccess.get_open_error())
	dir.list_dir_begin()
	var fn = dir.get_next()
	while fn != "":
		accounts.append(Account.load(ACCOUNTS_DIR + "/" + fn))
		fn = dir.get_next()
	dir.list_dir_end()
	are_accounts_loaded = true
	accounts_loaded.emit()


func _exit_tree() -> void:
	for a in accounts:
		a.save()

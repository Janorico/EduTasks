extends Control

const MAIN_SCENE = preload("res://software/main/main.tscn")
@onready var accounts_container = $AccountChooser/AccountsContainer
@onready var new_account_dialog = $NewAccountDialog
@onready var new_account_name_in = $NewAccountDialog/GridContainer/NameTextEdit

func _ready() -> void:
	randomize()
	if not AM.are_accounts_loaded:
		await AM.accounts_loaded
	for i in AM.accounts.size():
		add_account_button(i, AM.accounts[i].name)
	add_account_button(-1, "NEW_ACCOUNT")


func log_into(i: int) -> void:
	var m = MAIN_SCENE.instantiate()
	m.account = AM.accounts[i]
	get_tree().get_root().add_child(m)
	get_tree().current_scene = m
	var t = create_tween()
	t.finished.connect(get_parent().queue_free)
	t.set_parallel()
	t.tween_property(get_parent(), "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)


func add_account_button(i: int, n: String) -> void:
	var b = Button.new()
	b.text = n
	b.pressed.connect(_on_account_button_pressed.bind(i))
	accounts_container.add_child(b)


func _on_account_button_pressed(i: int) -> void:
	if i > -1:
		log_into(i)
	else:
		new_account_dialog.popup_centered()


func _on_new_account_dialog_about_to_popup() -> void:
	new_account_name_in.text = ""


func _on_new_account_dialog_confirmed() -> void:
	var a = Account.new(new_account_name_in.text)
	a.save()
	AM.accounts.append(a)
	log_into(AM.accounts.size() - 1)


func _on_rich_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)

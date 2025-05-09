extends MarginContainer

const CHECKMARK_ICON = preload("res://assets/icons/211644_checkmark_icon.svg")
const CROSS_ICON = preload("res://assets/icons/9104213_close_cross_remove_delete_icon.svg")
@onready var main = get_parent()
@onready var task_text: Label = $VBoxContainer/Input/TaskText
@onready var task_answer: LineEdit = $VBoxContainer/Input/TaskAnswer
@onready var message_icon: TextureRect = $VBoxContainer/Message/Content/Icon
@onready var message_label: Label = $VBoxContainer/Message/Content/Label
@onready var message_anim: AnimationPlayer = $VBoxContainer/Message/AnimationPlayer


func create_task() -> void:
	main.task.create()
	task_answer.clear()
	task_answer.grab_focus()
	task_text.text = main.task.get_text()


func check_answer() -> void:
	var result: int = main.task.check_result(task_answer.text)
	match result:
		Task.RESULT_NAN:
			show_message("INVALID_INPUT", CROSS_ICON)
		Task.RESULT_WRONG:
			main.score.wrong += 1
			show_message("WRONG", CROSS_ICON)
		Task.RESULT_CORRECT:
			show_message("CORRECT", CHECKMARK_ICON)
			main.score.correct += 1
			create_task()
	main.account.save()


func show_message(msg: String, icon: Texture2D) -> void:
		message_label.text = msg
		message_icon.texture = icon
		message_anim.play("notification")

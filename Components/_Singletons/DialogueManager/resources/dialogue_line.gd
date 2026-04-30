class_name DialogueLine extends DialogueItem


@export_enum(
"Colin","Perry","Ms. Barbara","Prof. Candice","...","???",
) var speaker_name: String

@export_enum(
"mc","dm","mt","pf","rand","unkn",
) var speaker_anim: String

@export_multiline var text: String = ""
@export_range(0.0, 1000, 0.1) var text_speed: float = 60.0

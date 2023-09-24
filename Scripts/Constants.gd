class_name Constants

const RENDER_SCALE := 3

const TAG_BALL := &"ball"
const TAG_PADDLE := &"paddle"
const TAG_DEFAULT := &"default"

static var SCREEN_WIDTH: int
static var SCREEN_HEIGHT: int


static func init() -> void:
	SCREEN_WIDTH = ProjectSettings.get("display/window/size/viewport_width")
	SCREEN_HEIGHT = ProjectSettings.get("display/window/size/viewport_height")

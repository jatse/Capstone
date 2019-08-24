package arm.node;

@:keep class OptionsSceneController extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _SetScene = new armory.logicnode.SetSceneNode(this);
		var _OnKeyboard = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard.property0 = "Started";
		_OnKeyboard.property1 = "escape";
		_OnKeyboard.addOutputs([_SetScene]);
		_SetScene.addInput(_OnKeyboard, 0);
		var _Scene = new armory.logicnode.SceneNode(this);
		_Scene.property0 = "MainMenu";
		_Scene.addOutputs([_SetScene]);
		_SetScene.addInput(_Scene, 0);
		_SetScene.addOutputs([new armory.logicnode.NullNode(this)]);
		_SetScene.addOutputs([new armory.logicnode.ObjectNode(this, "")]);
	}
}
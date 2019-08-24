package arm.node;

@:keep class MenuSceneController extends armory.logicnode.LogicTree {

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
		_OnKeyboard.property1 = "1";
		_OnKeyboard.addOutputs([_SetScene]);
		_SetScene.addInput(_OnKeyboard, 0);
		var _Scene = new armory.logicnode.SceneNode(this);
		_Scene.property0 = "SoloGame";
		_Scene.addOutputs([_SetScene]);
		_SetScene.addInput(_Scene, 0);
		_SetScene.addOutputs([new armory.logicnode.NullNode(this)]);
		_SetScene.addOutputs([new armory.logicnode.ObjectNode(this, "")]);
		var _SetScene_001 = new armory.logicnode.SetSceneNode(this);
		var _OnKeyboard_001 = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard_001.property0 = "Started";
		_OnKeyboard_001.property1 = "2";
		_OnKeyboard_001.addOutputs([_SetScene_001]);
		_SetScene_001.addInput(_OnKeyboard_001, 0);
		var _Scene_001 = new armory.logicnode.SceneNode(this);
		_Scene_001.property0 = "NetworkLobby";
		_Scene_001.addOutputs([_SetScene_001]);
		_SetScene_001.addInput(_Scene_001, 0);
		_SetScene_001.addOutputs([new armory.logicnode.NullNode(this)]);
		_SetScene_001.addOutputs([new armory.logicnode.ObjectNode(this, "")]);
		var _SetScene_002 = new armory.logicnode.SetSceneNode(this);
		var _OnKeyboard_002 = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard_002.property0 = "Started";
		_OnKeyboard_002.property1 = "3";
		_OnKeyboard_002.addOutputs([_SetScene_002]);
		_SetScene_002.addInput(_OnKeyboard_002, 0);
		var _Scene_002 = new armory.logicnode.SceneNode(this);
		_Scene_002.property0 = "Options";
		_Scene_002.addOutputs([_SetScene_002]);
		_SetScene_002.addInput(_Scene_002, 0);
		_SetScene_002.addOutputs([new armory.logicnode.NullNode(this)]);
		_SetScene_002.addOutputs([new armory.logicnode.ObjectNode(this, "")]);
	}
}
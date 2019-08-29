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
		var _Switch = new armory.logicnode.SwitchNode(this);
		var _OnKeyboard = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard.property0 = "Started";
		_OnKeyboard.property1 = "enter";
		_OnKeyboard.addOutputs([_Switch]);
		_Switch.addInput(_OnKeyboard, 0);
		var _GetProperty = new armory.logicnode.GetPropertyNode(this);
		_GetProperty.addInput(new armory.logicnode.ObjectNode(this, "menuController"), 0);
		_GetProperty.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		_GetProperty.addOutputs([_Switch]);
		_GetProperty.addOutputs([new armory.logicnode.StringNode(this, "")]);
		_Switch.addInput(_GetProperty, 0);
		var _Integer = new armory.logicnode.IntegerNode(this);
		_Integer.addInput(new armory.logicnode.IntegerNode(this, 0), 0);
		_Integer.addOutputs([_Switch]);
		_Switch.addInput(_Integer, 0);
		var _Integer_001 = new armory.logicnode.IntegerNode(this);
		_Integer_001.addInput(new armory.logicnode.IntegerNode(this, 1), 0);
		_Integer_001.addOutputs([_Switch]);
		_Switch.addInput(_Integer_001, 0);
		var _Integer_003 = new armory.logicnode.IntegerNode(this);
		_Integer_003.addInput(new armory.logicnode.IntegerNode(this, 2), 0);
		_Integer_003.addOutputs([_Switch]);
		_Switch.addInput(_Integer_003, 0);
		var _Integer_002 = new armory.logicnode.IntegerNode(this);
		_Integer_002.addInput(new armory.logicnode.IntegerNode(this, 3), 0);
		_Integer_002.addOutputs([_Switch]);
		_Switch.addInput(_Integer_002, 0);
		_Switch.addOutputs([new armory.logicnode.NullNode(this)]);
		_Switch.addOutputs([_SetScene]);
		var _SetScene_001 = new armory.logicnode.SetSceneNode(this);
		_SetScene_001.addInput(_Switch, 2);
		var _Scene_001 = new armory.logicnode.SceneNode(this);
		_Scene_001.property0 = "NetworkLobby";
		_Scene_001.addOutputs([_SetScene_001]);
		_SetScene_001.addInput(_Scene_001, 0);
		_SetScene_001.addOutputs([new armory.logicnode.NullNode(this)]);
		_SetScene_001.addOutputs([new armory.logicnode.ObjectNode(this, "")]);
		_Switch.addOutputs([_SetScene_001]);
		var _SetScene_002 = new armory.logicnode.SetSceneNode(this);
		_SetScene_002.addInput(_Switch, 3);
		var _Scene_002 = new armory.logicnode.SceneNode(this);
		_Scene_002.property0 = "Options";
		_Scene_002.addOutputs([_SetScene_002]);
		_SetScene_002.addInput(_Scene_002, 0);
		_SetScene_002.addOutputs([new armory.logicnode.NullNode(this)]);
		_SetScene_002.addOutputs([new armory.logicnode.ObjectNode(this, "")]);
		_Switch.addOutputs([_SetScene_002]);
		var _Shutdown = new armory.logicnode.ShutdownNode(this);
		_Shutdown.addInput(_Switch, 4);
		_Shutdown.addOutputs([new armory.logicnode.NullNode(this)]);
		_Switch.addOutputs([_Shutdown]);
		_SetScene.addInput(_Switch, 1);
		var _Scene = new armory.logicnode.SceneNode(this);
		_Scene.property0 = "SoloGame";
		_Scene.addOutputs([_SetScene]);
		_SetScene.addInput(_Scene, 0);
		_SetScene.addOutputs([new armory.logicnode.NullNode(this)]);
		_SetScene.addOutputs([new armory.logicnode.ObjectNode(this, "")]);
	}
}
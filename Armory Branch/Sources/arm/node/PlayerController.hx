package arm.node;

@:keep class PlayerController extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _PlayAction = new armory.logicnode.PlayActionNode(this);
		var _OnEvent = new armory.logicnode.OnEventNode(this);
		_OnEvent.property0 = "Idle";
		_OnEvent.addOutputs([_PlayAction]);
		_PlayAction.addInput(_OnEvent, 0);
		_PlayAction.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_PlayAction.addInput(new armory.logicnode.StringNode(this, "Idle"), 0);
		_PlayAction.addInput(new armory.logicnode.FloatNode(this, 0.20000000298023224), 0);
		_PlayAction.addOutputs([new armory.logicnode.NullNode(this)]);
		_PlayAction.addOutputs([new armory.logicnode.NullNode(this)]);
		var _PlayAction_001 = new armory.logicnode.PlayActionNode(this);
		var _OnEvent_001 = new armory.logicnode.OnEventNode(this);
		_OnEvent_001.property0 = "Forward";
		_OnEvent_001.addOutputs([_PlayAction_001]);
		_PlayAction_001.addInput(_OnEvent_001, 0);
		_PlayAction_001.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_PlayAction_001.addInput(new armory.logicnode.StringNode(this, "Forward"), 0);
		_PlayAction_001.addInput(new armory.logicnode.FloatNode(this, 0.20000000298023224), 0);
		_PlayAction_001.addOutputs([new armory.logicnode.NullNode(this)]);
		_PlayAction_001.addOutputs([new armory.logicnode.NullNode(this)]);
	}
}
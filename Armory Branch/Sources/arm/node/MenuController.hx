package arm.node;

@:keep class MenuController extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _SetProperty = new armory.logicnode.SetPropertyNode(this);
		var _OnInit = new armory.logicnode.OnInitNode(this);
		_OnInit.addOutputs([_SetProperty]);
		_SetProperty.addInput(_OnInit, 0);
		_SetProperty.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_SetProperty.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		var _Integer = new armory.logicnode.IntegerNode(this);
		_Integer.addInput(new armory.logicnode.IntegerNode(this, 0), 0);
		_Integer.addOutputs([_SetProperty]);
		_SetProperty.addInput(_Integer, 0);
		_SetProperty.addOutputs([new armory.logicnode.NullNode(this)]);
		var _SetProperty_003 = new armory.logicnode.SetPropertyNode(this);
		var _Gate = new armory.logicnode.GateNode(this);
		_Gate.property0 = "Greater";
		_Gate.property1 = 9.999999747378752e-05;
		var _OnUpdate = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate.property0 = "Update";
		_OnUpdate.addOutputs([_Gate]);
		_Gate.addInput(_OnUpdate, 0);
		var _GetProperty_003 = new armory.logicnode.GetPropertyNode(this);
		_GetProperty_003.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_GetProperty_003.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		_GetProperty_003.addOutputs([_Gate]);
		_GetProperty_003.addOutputs([new armory.logicnode.StringNode(this, "")]);
		_Gate.addInput(_GetProperty_003, 0);
		var _Integer_001 = new armory.logicnode.IntegerNode(this);
		_Integer_001.addInput(new armory.logicnode.IntegerNode(this, 3), 0);
		_Integer_001.addOutputs([_Gate]);
		_Gate.addInput(_Integer_001, 0);
		_Gate.addOutputs([_SetProperty_003]);
		_Gate.addOutputs([new armory.logicnode.NullNode(this)]);
		_SetProperty_003.addInput(_Gate, 0);
		_SetProperty_003.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_SetProperty_003.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		var _Integer_002 = new armory.logicnode.IntegerNode(this);
		_Integer_002.addInput(new armory.logicnode.IntegerNode(this, 0), 0);
		_Integer_002.addOutputs([_SetProperty_003]);
		_SetProperty_003.addInput(_Integer_002, 0);
		_SetProperty_003.addOutputs([new armory.logicnode.NullNode(this)]);
		var _SetProperty_004 = new armory.logicnode.SetPropertyNode(this);
		var _Gate_001 = new armory.logicnode.GateNode(this);
		_Gate_001.property0 = "Less";
		_Gate_001.property1 = 9.999999747378752e-05;
		var _OnUpdate_001 = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate_001.property0 = "Update";
		_OnUpdate_001.addOutputs([_Gate_001]);
		_Gate_001.addInput(_OnUpdate_001, 0);
		var _GetProperty_004 = new armory.logicnode.GetPropertyNode(this);
		_GetProperty_004.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_GetProperty_004.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		_GetProperty_004.addOutputs([_Gate_001]);
		_GetProperty_004.addOutputs([new armory.logicnode.StringNode(this, "")]);
		_Gate_001.addInput(_GetProperty_004, 0);
		var _Integer_003 = new armory.logicnode.IntegerNode(this);
		_Integer_003.addInput(new armory.logicnode.IntegerNode(this, 0), 0);
		_Integer_003.addOutputs([_Gate_001]);
		_Gate_001.addInput(_Integer_003, 0);
		_Gate_001.addOutputs([_SetProperty_004]);
		_Gate_001.addOutputs([new armory.logicnode.NullNode(this)]);
		_SetProperty_004.addInput(_Gate_001, 0);
		_SetProperty_004.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_SetProperty_004.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		var _Integer_004 = new armory.logicnode.IntegerNode(this);
		_Integer_004.addInput(new armory.logicnode.IntegerNode(this, 3), 0);
		_Integer_004.addOutputs([_SetProperty_004]);
		_SetProperty_004.addInput(_Integer_004, 0);
		_SetProperty_004.addOutputs([new armory.logicnode.NullNode(this)]);
		var _SetProperty_001 = new armory.logicnode.SetPropertyNode(this);
		var _OnEvent = new armory.logicnode.OnEventNode(this);
		_OnEvent.property0 = "menuDown";
		_OnEvent.addOutputs([_SetProperty_001]);
		_SetProperty_001.addInput(_OnEvent, 0);
		_SetProperty_001.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_SetProperty_001.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		var _Math = new armory.logicnode.MathNode(this);
		_Math.property0 = "Add";
		_Math.property1 = "false";
		var _GetProperty = new armory.logicnode.GetPropertyNode(this);
		_GetProperty.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_GetProperty.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		_GetProperty.addOutputs([_Math]);
		_GetProperty.addOutputs([new armory.logicnode.StringNode(this, "")]);
		_Math.addInput(_GetProperty, 0);
		_Math.addInput(new armory.logicnode.FloatNode(this, 1.0), 0);
		_Math.addOutputs([_SetProperty_001]);
		_SetProperty_001.addInput(_Math, 0);
		_SetProperty_001.addOutputs([new armory.logicnode.NullNode(this)]);
		var _SetProperty_002 = new armory.logicnode.SetPropertyNode(this);
		var _OnEvent_001 = new armory.logicnode.OnEventNode(this);
		_OnEvent_001.property0 = "menuUp";
		_OnEvent_001.addOutputs([_SetProperty_002]);
		_SetProperty_002.addInput(_OnEvent_001, 0);
		_SetProperty_002.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_SetProperty_002.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		var _Math_001 = new armory.logicnode.MathNode(this);
		_Math_001.property0 = "Subtract";
		_Math_001.property1 = "false";
		var _GetProperty_001 = new armory.logicnode.GetPropertyNode(this);
		_GetProperty_001.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_GetProperty_001.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		_GetProperty_001.addOutputs([_Math_001]);
		_GetProperty_001.addOutputs([new armory.logicnode.StringNode(this, "")]);
		_Math_001.addInput(_GetProperty_001, 0);
		_Math_001.addInput(new armory.logicnode.FloatNode(this, 1.0), 0);
		_Math_001.addOutputs([_SetProperty_002]);
		_SetProperty_002.addInput(_Math_001, 0);
		_SetProperty_002.addOutputs([new armory.logicnode.NullNode(this)]);
		var _SendEvent = new armory.logicnode.SendEventNode(this);
		var _OnKeyboard = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard.property0 = "Started";
		_OnKeyboard.property1 = "down";
		_OnKeyboard.addOutputs([_SendEvent]);
		_SendEvent.addInput(_OnKeyboard, 0);
		_SendEvent.addInput(new armory.logicnode.StringNode(this, "menuDown"), 0);
		_SendEvent.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_SendEvent.addOutputs([new armory.logicnode.NullNode(this)]);
		var _SendEvent_001 = new armory.logicnode.SendEventNode(this);
		var _OnKeyboard_001 = new armory.logicnode.OnKeyboardNode(this);
		_OnKeyboard_001.property0 = "Started";
		_OnKeyboard_001.property1 = "up";
		_OnKeyboard_001.addOutputs([_SendEvent_001]);
		_SendEvent_001.addInput(_OnKeyboard_001, 0);
		_SendEvent_001.addInput(new armory.logicnode.StringNode(this, "menuUp"), 0);
		_SendEvent_001.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_SendEvent_001.addOutputs([new armory.logicnode.NullNode(this)]);
	}
}
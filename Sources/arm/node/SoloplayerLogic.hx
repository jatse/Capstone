package arm.node;

@:keep class SoloplayerLogic extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		name = "SoloplayerLogic";
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _SetMaterialRGBParam = new armory.logicnode.SetMaterialRgbParamNode(this);
		var _Gate = new armory.logicnode.GateNode(this);
		_Gate.property0 = "Equal";
		_Gate.property1 = 9.999999747378752e-05;
		var _OnUpdate = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate.property0 = "Update";
		_OnUpdate.addOutputs([_Gate]);
		_Gate.addInput(_OnUpdate, 0);
		var _GetProperty = new armory.logicnode.GetPropertyNode(this);
		_GetProperty.addInput(new armory.logicnode.ObjectNode(this, "menuController"), 0);
		_GetProperty.addInput(new armory.logicnode.StringNode(this, "menuSelection"), 0);
		_GetProperty.addOutputs([_Gate]);
		_GetProperty.addOutputs([new armory.logicnode.StringNode(this, "")]);
		_Gate.addInput(_GetProperty, 0);
		var _Integer = new armory.logicnode.IntegerNode(this);
		_Integer.addInput(new armory.logicnode.IntegerNode(this, 0), 0);
		_Integer.addOutputs([_Gate]);
		_Gate.addInput(_Integer, 0);
		_Gate.addOutputs([_SetMaterialRGBParam]);
		var _SetMaterialRGBParam_001 = new armory.logicnode.SetMaterialRgbParamNode(this);
		_SetMaterialRGBParam_001.addInput(_Gate, 1);
		var _Material_001 = new armory.logicnode.MaterialNode(this);
		_Material_001.property0 = "soloplayerMat";
		_Material_001.addOutputs([_SetMaterialRGBParam_001]);
		_SetMaterialRGBParam_001.addInput(_Material_001, 0);
		_SetMaterialRGBParam_001.addInput(new armory.logicnode.StringNode(this, "spColor"), 0);
		_SetMaterialRGBParam_001.addInput(new armory.logicnode.ColorNode(this, 0.21404114365577698, 0.21404114365577698, 0.21404114365577698, 1.0), 0);
		_SetMaterialRGBParam_001.addOutputs([new armory.logicnode.NullNode(this)]);
		_Gate.addOutputs([_SetMaterialRGBParam_001]);
		_SetMaterialRGBParam.addInput(_Gate, 0);
		var _Material = new armory.logicnode.MaterialNode(this);
		_Material.property0 = "soloplayerMat";
		_Material.addOutputs([_SetMaterialRGBParam]);
		_SetMaterialRGBParam.addInput(_Material, 0);
		_SetMaterialRGBParam.addInput(new armory.logicnode.StringNode(this, "spColor"), 0);
		_SetMaterialRGBParam.addInput(new armory.logicnode.ColorNode(this, 1.0, 1.0, 1.0, 1.0), 0);
		_SetMaterialRGBParam.addOutputs([new armory.logicnode.NullNode(this)]);
	}
}
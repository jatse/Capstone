// Auto-generated
package ;
class Main {
    public static inline var projectName = 'game';
    public static inline var projectPackage = 'arm';
    public static function main() {
        iron.object.BoneAnimation.skinMaxBones = 17;
        iron.object.LightObject.cascadeCount = 4;
        iron.object.LightObject.cascadeSplitFactor = 0.800000011920929;
        armory.system.Starter.main(
            'mainMenu',
            0,
            true,
            true,
            true,
            1440,
            810,
            1,
            true,
            armory.renderpath.RenderPathCreator.get
        );
    }
}

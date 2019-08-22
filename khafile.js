// Auto-generated
let project = new Project('game');

project.addSources('Sources');
project.addLibrary("J:/ArmorySDK/armory");
project.addLibrary("J:/ArmorySDK/iron");
project.addParameter('armory.trait.WalkNavigation');
project.addParameter("--macro keep('armory.trait.WalkNavigation')");
project.addShaders("build_game/compiled/Shaders/*.glsl", { noembed: false});
project.addShaders("build_game/compiled/Hlsl/*.glsl", { noprocessing: true, noembed: false });
project.addAssets("build_game/compiled/Assets/**", { notinlist: true });
project.addAssets("build_game/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("Bundled/canvas/MenuUI.files", { notinlist: true });
project.addAssets("Bundled/canvas/MenuUI.json", { notinlist: true });
project.addAssets("J:/ArmorySDK/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("J:/ArmorySDK/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("J:/ArmorySDK/armory/Assets/smaa_search.png", { notinlist: true });
project.addDefine('arm_deferred');
project.addDefine('arm_csm');
project.addDefine('rp_hdr');
project.addDefine('rp_renderer=Deferred');
project.addDefine('rp_shadowmap');
project.addDefine('rp_shadowmap_cascade=1024');
project.addDefine('rp_shadowmap_cube=512');
project.addDefine('rp_background=World');
project.addDefine('rp_render_to_texture');
project.addDefine('rp_compositornodes');
project.addDefine('rp_antialiasing=SMAA');
project.addDefine('rp_supersampling=1');
project.addDefine('rp_ssgi=SSAO');
project.addDefine('arm_audio');
project.addDefine('arm_noembed');
project.addDefine('arm_soundcompress');
project.addDefine('arm_batch');
project.addDefine('arm_skin');
project.addDefine('arm_particles');


resolve(project);

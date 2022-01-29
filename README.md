# Auto Polygon2D Triangulation

![Icon](https://raw.githubusercontent.com/dweremeichik/godot_autopoly_plugin/main/asset_lib/asset_lib_icon.png)

Auto Polgon2D Triangulation is a plugin for the [Godot Engine](https://godotengine.org). 
It is designed to make 2D mesh deformation significantly faster and less painful by triangulating polygons (mesh) for you.

## How to install

Official installation instructions may be found [here](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html#installing-a-plugin).
You may either install through the [Godot Asset Library](http://godotengine.org/asset-library/asset/1174), or you can download a zip file directly from GitHub.

## How to use

![demonstration](https://github.com/dweremeichik/godot_autopoly_plugin/raw/main/asset_lib/auto_poly_plugin_preview.gif)

To use this plugin simply enable it, you can find the official instructions [here](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html#enabling-a-plugin).
When you add or remove a vertex (internal or external) in the Polygon2D UV Editor, your internal polygons will be automatically triangulated for you.

> Note: When adding an internal vertex, the polygons will be generated, but the Editor does not update immediatly. 
You can work around this by clicking on another tab of the editor, such as "UV" or by adding another internal vertex.  This is a bug with the Editor.


## License

This plugin is MIT licensed. The license file is located at [addons\auto_polygon2d_triangulation\LICENSE](https://github.com/dweremeichik/godot_autopoly_plugin/blob/main/addons/auto_polygon2d_triangulation/LICENSE).

## Special Thanks

Special thanks to [@Vic Ben](https://www.youtube.com/watch?v=liV5wLA_R1k) for creating the original C# tool script that this plugin is based on.

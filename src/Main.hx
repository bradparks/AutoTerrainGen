
import luxe.Input;

import luxe.Color;
import luxe.Component;
import luxe.options.SpriteOptions;
import luxe.Sprite;
import luxe.Vector;
import luxe.Text;
import phoenix.Texture;


import mint.Control;
import mint.types.Types;
import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;
import mint.layout.margins.Margins;

class Main extends luxe.Game {

    /**
     * Main rendered sprite, where everything is visible
     */
    public static var sprite:Sprite;

    /**
     * TODO: to change
     */
    public static var tile_size:Int = 16;

    var tilesets:Array<TileSet>;


    var disp : Text;
    var canvas: mint.Canvas;
    var rendering: LuxeMintRender;
    var layout: Margins;

    var window1:mint.Window;
    var tilesets_list:mint.List;
    var path_input:mint.TextEdit;
    var load_button:mint.Button;
    var generate_button:mint.Button;



    override function config(config:luxe.AppConfig) {

        return config;

    } //config

    override function ready() {

        tilesets = new Array<TileSet>();

        Luxe.renderer.clear_color.rgb(0x121219);

        

        init_canvas();
        
        var generator:Generator = new Generator();

    } //ready


    function init_canvas() {

        rendering = new LuxeMintRender();
        layout = new Margins();

        canvas = new mint.Canvas({
            name:'canvas',
            rendering: rendering,
            options: { color:new Color(1,1,1,0.0) },
            x: 0, y:0, w: 960, h: 640
        });

        disp = new Text({
            name:'display.text',
            pos: new Vector(Luxe.screen.w-10, Luxe.screen.h-10),
            align: luxe.TextAlign.right,
            align_vertical: luxe.TextAlign.bottom,
            point_size: 15,
            text: 'usage text goes here'
        });

        create_window1();

    }

    function create_window1() {

        window1 = new mint.Window({
            parent: canvas,
            name: 'window1',
            title: 'Configurate',
            options: {
                color:new Color().rgb(0x121212),
                color_titlebar:new Color().rgb(0x191919),
                label: { color:new Color().rgb(0x06b4fb) },
                close_button: { color:new Color().rgb(0x06b4fb) },
            },
            x:10, y:10, w:400, h: 400,
            w_min: 256, h_min:256,
            collapsible:true,
            closable: false,
        });

        path_input = new mint.TextEdit({
            parent: window1,
#if desktop
            text: '/home/zielak/dev/AutoTerrainGen/assets/template16.gif',
#else
            text: '/assets/template16.gif',
#end
            text_size: 12,
            name: 'path',
            options: { view: { color:new Color().rgb(0x19191c) } },
            x: 4, y: 35, w: 340, h: 28,
        });
        layout.margin(path_input, right, fixed, 58);

        load_button = new mint.Button({
            parent: window1,
            name: 'load',
            text: 'LOAD',
            options: { view: { color:new Color().rgb(0x008800) } },
            x: 345, y: 35, w: 54, h: 28,
        });
        layout.anchor(load_button, right, right);

        generate_button = new mint.Button({
            parent: window1,
            name: 'generate',
            text: 'Generate!',
            options: { view: { color:new Color().rgb(0x008800) } },
            x: 4, y: 65, w: 400, h: 28,
        });
        layout.margin(generate_button, right, fixed, 2);


        load_button.onmouseup.listen(function(e,_){
            load_tileset( path_input.text );
        });

        tilesets_list = new mint.List({
            parent: window1,
            name: 'list',
            options: { view: { color:new Color().rgb(0x19191c) } },
            x: 4, y: 100, w: 248, h: 400-100-4
        });

        layout.margin(tilesets_list, right, fixed, 4);
        layout.margin(tilesets_list, bottom, fixed, 4);


    } //create_window1

    function create_tileset_li(tileset:TileSet) {

        var _panel = new mint.Panel({
            parent: tilesets_list,
            name: 'panel_${tileset.id}',
            x:2, y:4, w:236, h:96,
        });

        layout.margin(_panel, right, fixed, 8);

        new mint.Image({
            parent: _panel, name: 'icon_${tileset.id}',
            x:8, y:8, w:80, h:80,
            path: tileset.id
        });

        var _title = new mint.Label({
            parent: _panel, name: 'label_${tileset.id}',
            mouse_input:true, x:96, y:8, w:148, h:18, text_size: 16,
            align: TextAlign.left, align_vertical: TextAlign.top,
            text: tileset.id,
        });

        layout.margin(_title, right, fixed, 8);

        return _panel;

    } //create_block




    override function onrender() {

        canvas.render();

    } //onrender

    override function update(dt:Float) {

        canvas.update(dt);

    } //update


    override function onmousemove(e) {

        canvas.mousemove( Convert.mouse_event(e) );

    }

    override function onmousewheel(e) {
        canvas.mousewheel( Convert.mouse_event(e) );
    }

    override function onmouseup(e) {
        canvas.mouseup( Convert.mouse_event(e) );
    }

    override function onmousedown(e) {
        canvas.mousedown( Convert.mouse_event(e) );
    }

    override function onkeydown(e:luxe.Input.KeyEvent) {
        canvas.keydown( Convert.key_event(e) );
    }

    override function ontextinput(e:luxe.Input.TextEvent) {
        canvas.textinput( Convert.text_event(e) );
    }

    override function onkeyup(e:luxe.Input.KeyEvent) {

        canvas.keyup( Convert.key_event(e) );

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    function load_tileset(url:String) {

        // trace('load_tileset(${url})');

        // var load:snow.api.Promise = Luxe.snow.io.module.data_load(url);
        var load:snow.api.Promise = Luxe.resources.load_texture(url);

        load.then(function(e:Texture){

            var tileset:TileSet = new TileSet(e);
            tilesets_list.add_item( create_tileset_li(tileset) );

        });

    }


} //Main

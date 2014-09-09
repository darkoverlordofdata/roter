part of roter;

class TwoD extends State {

  var map;
  var backgroundlayer;
  var blockedLayer;
  var player;
  var cursors;
  var items;
  var doors;
  var result;
  var targetTilemap;
  var targetX;
  var targetY;


  create() {
    map = game.add.tilemap('level1');

    //the first parameter is the tileset name as specified in Tiled, the second is the key to the asset
    map.addTilesetImage('tiles', 'gameTiles');

    //create layer
    backgroundlayer = map.createLayer('backgroundLayer');
    blockedLayer = map.createLayer('blockedLayer');

    //collision on blockedLayer
    map.setCollisionBetween(1, 100000, true, 'blockedLayer');

    //resizes the game world to match the layer dimensions
    backgroundlayer.resizeWorld();

    createItems();
    createDoors();

    //create player
    var result = findObjectsByType('playerStart', map, 'objectsLayer');
    player = game.add.sprite(result[0]['x'], result[0]['y'], 'player');
    game.physics.arcade.enable(player);

    //the camera will follow the player in the world
    game.camera.follow(player);

    //move player with cursor keys
    cursors = game.input.keyboard.createCursorKeys();

  }

  createItems() {
    //create items
    items = game.add.group();
    items.enableBody = true;
    var item;
    result = findObjectsByType('item', map, 'objectsLayer');
    result.forEach((element){
      createFromTiledObject(element, items);
    });
  }
  createDoors() {
    //create doors
    doors = game.add.group();
    doors.enableBody = true;
    result = findObjectsByType('door', map, 'objectsLayer');

    result.forEach((element){
      createFromTiledObject(element, doors);
    });
  }

  //find objects in a Tiled layer that containt a property called "type" equal to a certain value
  findObjectsByType(type, map, layer) {
    var result = [];
    map.objects[layer].forEach((element){
      JsObject elem = new JsObject.jsify(element);

      if(elem['properties']['type'] == type) {
        //Phaser uses top left, Tiled bottom left so we have to adjust
        //also keep in mind that the cup images are a bit smaller than the tile which is 16x16
        //so they might not be placed in the exact position as in Tiled
        elem['y'] -= map.tileHeight;
        result.add(elem);
      }      
    });
    return result;
  }
  //create a sprite from an object
  createFromTiledObject(element, group) {
    var sprite = group.create(element['x'], element['y'], element['properties']['sprite']);

      //copy all properties to the sprite
    var keys = context['Object'].callMethod('keys', [element['properties']]);
    keys.forEach((key) {
      var v = element['properties'][key];
      switch(key) {
        //case 'sprite': sprite.sprite = element['properties'][key];break;

        case 'type'         : sprite.type   = v;break;
        case 'targetTilemap': targetTilemap = v;break;
        case 'targetX'      : targetX       = v;break;
        case 'targetY'      : targetY       = v;break;

        default: print("What about $key?");
      }
    });

//      Object.keys(element['properties']).forEach((key){
//        sprite[key] = element['properties'][key];
//      });
  }
  update() {
    //collision
    game.physics.arcade.collide(player, blockedLayer);
    game.physics.arcade.overlap(player, items, collect, null);
    game.physics.arcade.overlap(player, doors, enterDoor, null);

    //player movement
    player.body.velocity.y = 0;
    player.body.velocity.x = 0;

    if(cursors.up.isDown) {
      player.body.velocity.y -= 50;
    }
    else if(cursors.down.isDown) {
      player.body.velocity.y += 50;
    }
    if(cursors.left.isDown) {
      player.body.velocity.x -= 50;
    }
    else if(cursors.right.isDown) {
      player.body.velocity.x += 50;
    }
  }
  collect(player, collectable) {
    window.console.log('yummy!');

    //remove sprite
    try {
      collectable.destroy();
    }
    catch(ex) {
      print("Exception $ex");
    }
  }
  enterDoor(player, door) {
    print(door);
    window.console.log('entering door that will take you to '+targetTilemap+' on x:'+targetX+' and y:'+targetY);
  }
}
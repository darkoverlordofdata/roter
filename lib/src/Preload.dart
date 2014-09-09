part of roter;

class Preload extends State {

  Sprite preloadBar;

  preload() {
    //show loading screen
    preloadBar = add.sprite(game.world.centerX, game.world.centerY, 'preloadbar');
    preloadBar.anchor.setTo(0.5);

    load.setPreloadSprite(preloadBar);

    //load game assets
    load.tilemap('level1', 'assets/tilemaps/level1.json', null, Tilemap.TILED_JSON);
    load.image('gameTiles', 'assets/images/tiles.png');
    load.image('greencup', 'assets/images/greencup.png');
    load.image('bluecup', 'assets/images/bluecup.png');
    load.image('player', 'assets/images/player.png');
    load.image('browndoor', 'assets/images/browndoor.png');
    
  }
  create() {
    state.start('Game');
  }
}
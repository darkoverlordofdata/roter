part of roter;
//setting game configuration and loading the assets for the loading screen
class Boot extends State {
  
  preload() {
    //assets we'll use in the loading screen
    load.image('preloadbar', 'assets/images/preloader-bar.png');
  }
  create() {
    //loading screen will have a white background
    game.stage.backgroundColor = 0xffffff;

    //scaling options
    scale.scaleMode = ScaleManager.SHOW_ALL;
    
    //have the game centered horizontally
    scale.pageAlignHorizontally = true;
    scale.pageAlignVertically = true;

    //screen size will be set automatically
    scale.setScreenSize(true);

    //physics system
    game.physics.startSystem(Physics.ARCADE);
    
    state.start('Preload');
  }
}
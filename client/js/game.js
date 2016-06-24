(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  var Character, RANDOM_FACTOR, map, rand, shuffle;

  map = require('./map.coffee');

  RANDOM_FACTOR = 10;

  rand = function(a, b) {
    return Math.floor(Math.random() * (b - a)) + a;
  };

  shuffle = function(arr) {
    var i, j, tempi, tempj;
    i = arr.length;
    if (i === 0) {
      return false;
    }
    while (--i) {
      j = Math.floor(Math.random() * (i + 1));
      tempi = arr[i];
      tempj = arr[j];
      arr[i] = tempj;
      arr[j] = tempi;
    }
    return arr;
  };

  Character = (function() {
    Character.prototype.PER_TYPE = {
      tri: {
        VELOCITY: 80,
        ACCELERATION: 40
      },
      squ: {
        VELOCITY: 55,
        ACCELERATION: 25
      },
      rou: {
        VELOCITY: 30,
        ACCELERATION: 15
      }
    };

    function Character(state, type, color, position) {
      this.type = type;
      this.color = color;
      this.state = state;
      this.sprite = new Kiwi.GameObjects.Sprite(this.state, this.state.textures[type + "_" + color], position.x, position.y, true);
      state.addChild(this.sprite);
      this.sprite.update = ((function(_this) {
        return function() {
          return _this.update();
        };
      })(this));
      this.sprite.physics = this.sprite.components.add(new Kiwi.Components.ArcadePhysics(this.sprite, this.sprite.box));
      this.velocity = this.PER_TYPE[this.type].VELOCITY + rand(-RANDOM_FACTOR, RANDOM_FACTOR);
      this.acceleration = this.PER_TYPE[this.type].ACCELERATION + rand(-RANDOM_FACTOR / 2, RANDOM_FACTOR / 2);
      this.keypushed = {
        left: false,
        right: false,
        up: false,
        down: false
      };
      this.move = {
        VX: 0,
        VY: 0,
        AX: 0,
        AY: 0
      };
    }

    Character.prototype.update = function() {
      var old_x, old_y;
      old_x = this.sprite.x;
      old_y = this.sprite.y;
      if (this.state.rightKey.isDown && !this.keypushed['right']) {
        this.move.VX += this.velocity;
        this.move.AX += this.acceleration;
      } else if (!this.state.rightKey.isDown && this.keypushed['right']) {
        this.move.VX -= this.velocity;
        this.move.AX -= this.acceleration;
      }
      this.keypushed['right'] = this.state.rightKey.isDown;
      if (this.state.leftKey.isDown && !this.keypushed['left']) {
        this.move.VX -= this.velocity;
        this.move.AX -= this.acceleration;
      } else if (!this.state.leftKey.isDown && this.keypushed['left']) {
        this.move.VX += this.velocity;
        this.move.AX += this.acceleration;
      }
      this.keypushed['left'] = this.state.leftKey.isDown;
      if (this.state.upKey.isDown && !this.keypushed['up']) {
        this.move.VY -= this.velocity;
        this.move.AY -= this.acceleration;
      } else if (!this.state.upKey.isDown && this.keypushed['up']) {
        this.move.VY += this.velocity;
        this.move.AY += this.acceleration;
      }
      this.keypushed['up'] = this.state.upKey.isDown;
      if (this.state.downKey.isDown && !this.keypushed['down']) {
        this.move.VY += this.velocity;
        this.move.AY += this.acceleration;
      } else if (!this.state.downKey.isDown && this.keypushed['down']) {
        this.move.VY -= this.velocity;
        this.move.AY -= this.acceleration;
      }
      this.keypushed['down'] = this.state.downKey.isDown;
      this.sprite.physics.acceleration = new Kiwi.Geom.Point(this.move.AX, this.move.AY);
      this.sprite.physics.velocity = new Kiwi.Geom.Point(this.move.VX, this.move.VY);
      this.sprite.physics.update();
      if (this.detect_collision()) {
        this.sprite.x = old_x;
        this.sprite.y = old_y;
      }
      return console.log(this.detect_collision());
    };

    Character.prototype.detect_collision = function() {
      var blocker, blocker_to_rectangle, blockers, circle, k, len, middle;
      blocker_to_rectangle = function(blocker) {
        return new Kiwi.Geom.Rectangle(blocker.ul.x, blocker.ul.y, blocker.br.x - blocker.ul.x, blocker.br.y - blocker.ul.y);
      };
      middle = function(box) {
        return {
          x: box.x + box.width / 2,
          y: box.y + box.height / 2
        };
      };
      blockers = map.blockers;
      for (k = 0, len = blockers.length; k < len; k++) {
        blocker = blockers[k];
        circle = new Kiwi.Geom.Circle((middle(this.sprite.box.bounds)).x, (middle(this.sprite.box.bounds)).y, this.sprite.box.bounds.width * 2 / 3);
        if (!(Kiwi.Geom.Intersect.circleToRectangle(circle, blocker_to_rectangle(blocker))).result) {
          continue;
        } else {
          return blocker;
        }
      }
      return false;
    };

    return Character;

  })();

  Character.prototype.spawn = function(game) {
    var k, l, len, len1, len2, m, obj_type, ref, ref1, ref2, results, spawns, thisspawn;
    spawns = map.spawns.w;
    spawns = shuffle(spawns);
    thisspawn = spawns[0];
    ref = ['tri', 'squ', 'rou'];
    for (k = 0, len = ref.length; k < len; k++) {
      obj_type = ref[k];
      game.characters.push(new Character(game.ingame, obj_type, 'w', thisspawn));
    }
    thisspawn = spawns[1];
    ref1 = ['squ', 'rou'];
    for (l = 0, len1 = ref1.length; l < len1; l++) {
      obj_type = ref1[l];
      game.characters.push(new Character(game.ingame, obj_type, 'w', thisspawn));
    }
    thisspawn = spawns[2];
    ref2 = ['rou'];
    results = [];
    for (m = 0, len2 = ref2.length; m < len2; m++) {
      obj_type = ref2[m];
      results.push(game.characters.push(new Character(game.ingame, obj_type, 'w', thisspawn)));
    }
    return results;
  };

  module.exports = Character;

}).call(this);

},{"./map.coffee":3}],2:[function(require,module,exports){
(function() {
  var Character, Game, game;

  Character = require('./character.coffee');

  console.log('Character:', Character);

  Game = (function() {
    Game.prototype.options = {
      width: 1200,
      height: 600
    };

    Game.prototype.characters_names = ['tri_w', 'tri_b', 'squ_w', 'squ_b', 'squ_w', 'rou_w', 'rou_b'];

    function Game() {
      var thisgame;
      console.log('New game');
      this.game = new Kiwi.Game('gamecanvas', 'Triangle Round Square', null, this.options);
      this.ingame = new Kiwi.State('ingame');
      thisgame = this;
      thisgame.characters = [];
      this.ingame.preload = function() {
        var character, i, len, ref;
        Kiwi.State.prototype.preload.call(this);
        this.addImage('map_top', 'img/map_top.png');
        this.addImage('map_bottom', 'img/map_bottom.png');
        ref = thisgame.characters_names;
        for (i = 0, len = ref.length; i < len; i++) {
          character = ref[i];
          this.addImage(character, "img/" + character + ".png");
        }
        console.log(this.textures);
      };
      this.ingame.create = function() {
        Kiwi.State.prototype.create.call(this);
        this.map_bottom = new Kiwi.GameObjects.StaticImage(this, this.textures['map_bottom']);
        this.addChild(this.map_bottom);
        Character.prototype.spawn(thisgame);
        this.map_top = new Kiwi.GameObjects.StaticImage(this, this.textures['map_top']);
        this.addChild(this.map_top);
        this.leftKey = this.game.input.keyboard.addKey(Kiwi.Input.Keycodes.LEFT);
        this.rightKey = this.game.input.keyboard.addKey(Kiwi.Input.Keycodes.RIGHT);
        this.upKey = this.game.input.keyboard.addKey(Kiwi.Input.Keycodes.UP);
        return this.downKey = this.game.input.keyboard.addKey(Kiwi.Input.Keycodes.DOWN);
      };
      this.ingame.update = function() {
        return Kiwi.State.prototype.update.call(this);
      };
    }

    Game.prototype.start = function() {
      return this.game.states.addState(this.ingame, true);
    };

    return Game;

  })();

  game = new Game();

  game.start();

}).call(this);

},{"./character.coffee":1}],3:[function(require,module,exports){
(function() {
  var map;

  map = {
    spawns: {
      w: [
        {
          x: 65,
          y: 65
        }, {
          x: 65,
          y: 275
        }, {
          x: 65,
          y: 505
        }
      ]
    },
    blockers: [
      {
        ul: {
          x: 0,
          y: 0
        },
        br: {
          x: 25,
          y: 600
        }
      }, {
        ul: {
          x: 30,
          y: 575
        },
        br: {
          x: 1200,
          y: 600
        }
      }, {
        ul: {
          x: -5,
          y: 0
        },
        br: {
          x: 1200,
          y: 30
        }
      }, {
        ul: {
          x: 1175,
          y: 0
        },
        br: {
          x: 1200,
          y: 600
        }
      }, {
        ul: {
          x: 30,
          y: 135
        },
        br: {
          x: 85,
          y: 190
        }
      }, {
        ul: {
          x: 30,
          y: 410
        },
        br: {
          x: 85,
          y: 465
        }
      }, {
        ul: {
          x: 1115,
          y: 135
        },
        br: {
          x: 1175,
          y: 190
        }
      }, {
        ul: {
          x: 1115,
          y: 410
        },
        br: {
          x: 1175,
          y: 460
        }
      }, {
        ul: {
          x: 145,
          y: 30
        },
        br: {
          x: 200,
          y: 240
        }
      }, {
        ul: {
          x: 200,
          y: 30
        },
        br: {
          x: 230,
          y: 165
        }
      }, {
        ul: {
          x: 230,
          y: 30
        },
        br: {
          x: 290,
          y: 110
        }
      }, {
        ul: {
          x: 290,
          y: 30
        },
        br: {
          x: 335,
          y: 155
        }
      }, {
        ul: {
          x: 860,
          y: 30
        },
        br: {
          x: 910,
          y: 155
        }
      }, {
        ul: {
          x: 910,
          y: 30
        },
        br: {
          x: 970,
          y: 100
        }
      }, {
        ul: {
          x: 975,
          y: 30
        },
        br: {
          x: 1055,
          y: 160
        }
      }, {
        ul: {
          x: 1000,
          y: 160
        },
        br: {
          x: 1055,
          y: 240
        }
      }, {
        ul: {
          x: 145,
          y: 360
        },
        br: {
          x: 200,
          y: 575
        }
      }, {
        ul: {
          x: 200,
          y: 430
        },
        br: {
          x: 225,
          y: 575
        }
      }, {
        ul: {
          x: 228,
          y: 500
        },
        br: {
          x: 286,
          y: 472
        }
      }, {
        ul: {
          x: 290,
          y: 440
        },
        br: {
          x: 340,
          y: 573
        }
      }, {
        ul: {
          x: 855,
          y: 435
        },
        br: {
          x: 910,
          y: 546
        }
      }, {
        ul: {
          x: 915,
          y: 495
        },
        br: {
          x: 970,
          y: 545
        }
      }, {
        ul: {
          x: 975,
          y: 440
        },
        br: {
          x: 1055,
          y: 570
        }
      }, {
        ul: {
          x: 1000,
          y: 350
        },
        br: {
          x: 1055,
          y: 440
        }
      }, {
        ul: {
          x: 296,
          y: 255
        },
        br: {
          x: 395,
          y: 345
        }
      }, {
        ul: {
          x: 810,
          y: 250
        },
        br: {
          x: 900,
          y: 345
        }
      }, {
        ul: {
          x: 490,
          y: 30
        },
        br: {
          x: 515,
          y: 80
        }
      }, {
        ul: {
          x: 515,
          y: 80
        },
        br: {
          x: 540,
          y: 135
        }
      }, {
        ul: {
          x: 545,
          y: 135
        },
        br: {
          x: 570,
          y: 190
        }
      }, {
        ul: {
          x: 570,
          y: 190
        },
        br: {
          x: 630,
          y: 240
        }
      }, {
        ul: {
          x: 630,
          y: 135
        },
        br: {
          x: 655,
          y: 190
        }
      }, {
        ul: {
          x: 655,
          y: 90
        },
        br: {
          x: 685,
          y: 135
        }
      }, {
        ul: {
          x: 655,
          y: 90
        },
        br: {
          x: 685,
          y: 135
        }
      }, {
        ul: {
          x: 680,
          y: 30
        },
        br: {
          x: 715,
          y: 80
        }
      }, {
        ul: {
          x: 575,
          y: 365
        },
        br: {
          x: 625,
          y: 570
        }
      }, {
        ul: {
          x: 545,
          y: 410
        },
        br: {
          x: 655,
          y: 465
        }
      }, {
        ul: {
          x: 520,
          y: 465
        },
        br: {
          x: 685,
          y: 515
        }
      }, {
        ul: {
          x: 490,
          y: 520
        },
        br: {
          x: 710,
          y: 570
        }
      }
    ]
  };

  module.exports = map;

}).call(this);

},{}]},{},[2])
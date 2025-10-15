package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flxanimate.FlxAnimate;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	var deathSpriteRetry:FlxSprite;
	var deathSpriteNene:FlxSprite;

	var CAMERA_ZOOM_DURATION:Float = 0.5;

	var targetCameraZoom:Float = 1.0;

	var deathQuoteSound:Null<FlxSound> = null;

	var deathSpriteRetry2:FlxAnimate;

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (daStage)
		{
			case 'mall':
				daBf = 'pico-christmas';
			case 'school':
				stageSuffix = '-pixel';
				daBf = 'pico-pixel';
			default:
				daBf = 'pico-playable';
		}

		if(PlayState.SONG.song.toLowerCase() == 'stress')
		daBf = 'pico-holding-nene';

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		var playState = cast(FlxG.state, PlayState);
		@:privateAccess
		if(playState.boyfriend.shader != null && daBf != 'pico-pixel' && PlayState.curStage != 'tank')
		bf.shader = playState.boyfriend.shader;
		add(bf);

		bf.updateHitbox();

		if(daBf == 'pico-holding-nene')
		{
		deathSpriteRetry2 = new FlxAnimate(bf.x + 15, bf.y + 39);
		Paths.loadAnimateAtlas(deathSpriteRetry2, 'picoAndNene-DEAD');
		deathSpriteRetry2.anim.addBySymbolIndices('intro', 'Pico Nene death', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45], 24, false);
		deathSpriteRetry2.anim.addBySymbolIndices('loop', 'Pico Nene death', [46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67], 24, true);
		deathSpriteRetry2.anim.addBySymbolIndices('confirm', 'Pico Nene death', [68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132], 24, true);
		add(deathSpriteRetry2);
		deathSpriteRetry2.anim.play('intro');
		deathSpriteRetry2.antialiasing = true;
		bf.visible = false;
		}

		var playState = cast(FlxG.state, PlayState);

		@:privateAccess
		targetCameraZoom = playState.stageZoom;

		@:privateAccess
		{
		camFollow = new FlxObject(playState.camFollow.x, playState.camFollow.y, 1, 1);
		camFollow.x = getMidPointOld(bf).x + 10;
		camFollow.y = getMidPointOld(bf).y + -40;
		}
		add(camFollow);

		if(daBf == 'pico-holding-nene')
		FlxG.sound.play(Paths.sound('fnf_loss_sfx-pico-and-nene', 'week7'));
		else
		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

		if(daBf == 'pico-holding-nene')
		{
		new FlxTimer().start(0.58, function(tmr:FlxTimer)
		{
		afterPicoDeathNeneIntro();
		});
		}

		FlxG.camera.setFilters([]);

		createDeathSprites();

		if(daBf != 'pico-pixel' && daBf != 'pico-holding-nene')
		add(deathSpriteRetry);
		deathSpriteRetry.antialiasing = true;
		if(daBf != 'pico-holding-nene')
		add(deathSpriteNene);
		deathSpriteNene.antialiasing = daBf == 'pico-pixel' ? false : true;
		deathSpriteNene.animation.play("throw");

		FlxG.camera.follow(camFollow, LOCKON, 0.01);
	}

	function getMidPointOld(spr:FlxSprite, ?point:FlxPoint):FlxPoint
	{
		if (point == null) point = FlxPoint.get();
		return point.set(spr.x + spr.frameWidth * 0.5 * spr.scale.x, spr.y + spr.frameHeight * 0.5 * spr.scale.y);
	}

	function createDeathSprites() {
		deathSpriteRetry = new FlxSprite(0, 0);
		deathSpriteRetry.frames = Paths.getSparrowAtlas("Pico_Death_Retry", 'weekend1');

		if (bf.shader != null)
		{
		deathSpriteRetry.shader = bf.shader;
		}
		deathSpriteRetry.animation.addByPrefix('idle', "Retry Text Loop0", 24, true);
		deathSpriteRetry.animation.addByPrefix('confirm', "Retry Text Confirm0", 24, false);

		deathSpriteRetry.visible = false;

		deathSpriteNene = new FlxSprite(0, 0);
		if(bf.curCharacter == 'pico-christmas')
		deathSpriteNene.frames = Paths.getSparrowAtlas("christmas/neneChristmas/neneChristmasKnife", 'week5');
		else if(bf.curCharacter == 'pico-pixel')
		deathSpriteNene.frames = Paths.getSparrowAtlas("weeb/nenePixel/nenePixelKnifeToss", 'week6');
		else
		deathSpriteNene.frames = Paths.getSparrowAtlas("NeneKnifeToss", 'weekend1');
		var playState = cast(FlxG.state, PlayState);
		@:privateAccess
		{
		deathSpriteNene.x = playState.gf.originalPosition.x + 120;
		deathSpriteNene.y = playState.gf.originalPosition.y - 200;
		if(bf.curCharacter == 'pico-pixel')
		{
		deathSpriteNene.x = playState.gf.originalPosition.x + 280;
		deathSpriteNene.y = playState.gf.originalPosition.y + 170;
		}
		}
		if(bf.curCharacter != 'pico-pixel')
		{
		deathSpriteNene.origin.x = 172;
		deathSpriteNene.origin.y = 205;
		}
		if(bf.curCharacter == 'pico-christmas')
		deathSpriteNene.animation.addByPrefix('throw', "knife toss xmas0", 24, false);
		else if(bf.curCharacter == 'pico-pixel')
		{
		deathSpriteNene.animation.addByPrefix('throw', "knifetosscolor0", 24, false);
		deathSpriteNene.scale.set(6, 6);
		}
		else
		deathSpriteNene.animation.addByPrefix('throw', "knife toss0", 24, false);
		deathSpriteNene.visible = true;
		deathSpriteNene.animation.finishCallback = function(name:String)
		{
			deathSpriteNene.visible = false;
		}
	}

	public static function lerp(base:Float, target:Float, progress:Float):Float
	{
		return base + progress * (target - base);
	}

	public static function smoothLerp(current:Float, target:Float, elapsed:Float, duration:Float, precision:Float = 1 / 100):Float
	{
		if (current == target) return target;

		var result:Float = lerp(current, target, 1 - Math.pow(precision, elapsed / duration));

		if (Math.abs(result - target) < (precision * target)) result = target;

		return result;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.camera.zoom = smoothLerp(FlxG.camera.zoom, targetCameraZoom, elapsed, CAMERA_ZOOM_DURATION);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == "firstDeath" && bf.animation.curAnim.curFrame == 36 - 1) {
			if (deathSpriteRetry != null && deathSpriteRetry.animation != null)
			{
				deathSpriteRetry.animation.play('idle');
				deathSpriteRetry.visible = true;

				deathSpriteRetry.x = bf.x + 195;
				deathSpriteRetry.y = bf.y - 70;
			}

			var playState = cast(FlxG.state, PlayState);
			if(!isEnding)
			{
			if(bf.curCharacter == 'pico-holding-nene')
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), 0.2);
			else
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
			}
			bf.playAnim('deathLoop');
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}

		if(deathSpriteRetry2 != null && deathSpriteRetry2.anim.curSymbol.name == 'intro' && deathSpriteRetry2.anim.finished)
		deathSpriteRetry2.anim.play('loop');
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			if (deathQuoteSound != null)
			{
			deathQuoteSound.stop();
			deathQuoteSound = null;
			}
			if(deathSpriteRetry != null)
			{
			deathSpriteRetry.animation.play('confirm');
			deathSpriteRetry.x -= 250;
			deathSpriteRetry.y -= 200;
			}
			if(deathSpriteRetry2 != null)
			{
			deathSpriteRetry2.anim.play('confirm');
			}
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}

  function afterPicoDeathNeneIntro():Void
  {
    // Delay the death quote because the first death animation is so fast.
    new FlxTimer().start(1.5, function(_) {
      // Prevent playing the death quote twice or if skipping the death animation.
			if(isEnding) return;
			deathQuoteSound = new FlxSound().loadEmbedded(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 10), 'week7'), false, false, function()
			{
			FlxG.sound.music.fadeIn(4, 0.2, 1);
			});
			FlxG.sound.list.add(deathQuoteSound);
			deathQuoteSound.play(true);
    });
  }
}
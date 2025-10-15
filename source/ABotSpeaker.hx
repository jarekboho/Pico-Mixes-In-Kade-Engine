package;

import flixel.FlxObject;
import flixel.util.FlxAxes;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxSprite;
import flxanimate.FlxAnimate;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import funkin.vis.dsp.SpectralAnalyzer;

class ABotSpeaker extends FlxTypedSpriteGroup<FlxSprite>
{
	public var bg:FlxSprite;
	public var vizSprites:Array<FlxSprite> = [];
	public var eyeBg:FlxSprite;
	public var eyes:FlxAnimate;
	public var speaker:FlxAnimate;

	final VIZ_MAX = 7;
	final VIZ_POS_X:Array<Float> = [0, 59, 56, 66, 54, 52, 51];
	final VIZ_POS_Y:Array<Float> = [0, -8, -3.5, -0.4, 0.5, 4.7, 7];

	var analyzer:SpectralAnalyzer;

	public var snd(default, set):FlxSound;
	function set_snd(changed:FlxSound)
	{
		snd = changed;
		initAnalyzer();
		return snd;
	}

	public var abotHead:FlxSprite;
	public var abotSpeaker:FlxSprite;
	public var abot:FlxSprite;

	public function new(x:Float, y:Float, pixel:Bool) {
		super(x, y);

		if(pixel)
		{
		abotHead = new FlxSprite(296 - 325, 430 + 72);
		abotHead.frames = Paths.getSparrowAtlas('weeb/abotPixel/abotHead', 'week6');
		abotHead.scale.set(6, 6);
		abotHead.antialiasing = false;
		abotHead.animation.addByPrefix('toleft', 'toleft0', 24, false);
		abotHead.animation.addByPrefix('toright', 'toright0', 24, false);
		abotHead.animation.play('toright', true);
		add(abotHead);

		abotSpeaker = new FlxSprite(296 - 78, 430 + 9);
		abotSpeaker.frames = Paths.getSparrowAtlas('weeb/abotPixel/aBotPixelSpeaker', 'week6');
		abotSpeaker.scale.set(6, 6);
		abotSpeaker.origin.x = Math.round(abotSpeaker.origin.x);
		abotSpeaker.origin.y = Math.round(abotSpeaker.origin.y);
		abotSpeaker.antialiasing = false;
		abotSpeaker.animation.addByPrefix('danceLeft', 'danceLeft', 24, false);
		abotSpeaker.animation.play('danceLeft', true);
		add(abotSpeaker);
		}

		bg = new FlxSprite(-100 + 150, 216 + 30).loadGraphic(pixel ? Paths.image('weeb/abotPixel/aBotPixelBack', 'week6') : Paths.image('abot/stereoBG'));
		if(pixel)
		bg.scale.set(6.1, 6);
		bg.antialiasing = pixel ? false : true;
		add(bg);
		if(pixel)
		bg.setPosition(this.x + 296 - 55, this.y + 430 + 0);

		if(pixel)
		{
		VIZ_POS_X = [0, 7 * 6, 8 * 6, 9 * 6, 10 * 6, 6 * 6, 7 * 6];
		VIZ_POS_Y = [0, -2 * 6, -1 * 6, 0, 0, 1 * 6, 2 * 6];
		}

		var vizX:Float = 0;
		var vizY:Float = 0;
		var vizFrames = Paths.getSparrowAtlas('aBotViz');
		if(pixel)
		vizFrames = Paths.getSparrowAtlas('weeb/abotPixel/aBotVizPixel', 'week6');
		for (i in 1...VIZ_MAX+1)
		{
			vizX += VIZ_POS_X[i-1];
			vizY += VIZ_POS_Y[i-1];
			var viz:FlxSprite = new FlxSprite(vizX, vizY);
			viz.frames = vizFrames;
			viz.animation.addByPrefix('VIZ', 'viz$i', 0);
			viz.animation.play('VIZ', true);
			viz.animation.curAnim.finish();
			viz.antialiasing = pixel ? false : true;
			if(pixel)
			viz.scale.set(6, 6);
			vizSprites.push(viz);
			if(!pixel)
			{
			viz.updateHitbox();
			viz.centerOffsets();
			}
			add(viz);
			viz.visible = false;
			if(pixel)
			{
			viz.x += 296 - 160;
			viz.y += 430 + 13;
			}
			else
			{
			viz.x += -100 + 200;
			viz.y += 216 + 84;
			}
		}

		eyeBg = new FlxSprite(-100 + 40, 216 + 250).makeGraphic(1, 1, FlxColor.WHITE);
		eyeBg.scale.set(160, 60);
		eyeBg.updateHitbox();
		if(!pixel) add(eyeBg);

		eyes = new FlxAnimate(-100 - 507, 216 - 492);
		Paths.loadAnimateAtlas(eyes, 'abot/systemEyes');
		eyes.anim.addBySymbolIndices('lookleft', 'a bot eyes lookin', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 24, false);
		eyes.anim.addBySymbolIndices('lookright', 'a bot eyes lookin', [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35], 24, false);
		eyes.anim.play('lookright', true);
		eyes.anim.curInstance.matrix.tx = 562.9;
		eyes.anim.curInstance.matrix.ty = 731.2;
		eyes.anim.curFrame = eyes.anim.length - 1;
		eyes.antialiasing = true;
		if(!pixel) add(eyes);

		speaker = new FlxAnimate(-100, 216);
		Paths.loadAnimateAtlas(speaker, 'abot/abotSystem');
		speaker.anim.addBySymbol('anim', 'Abot System', 24, false);
		speaker.anim.play('anim', true);
		speaker.anim.curFrame = speaker.anim.length - 1;
		speaker.antialiasing = true;
		if(!pixel) add(speaker);

		if(pixel)
		{
		abot = new FlxSprite(296, 430);
		abot.frames = Paths.getSparrowAtlas('weeb/abotPixel/aBotPixelBody', 'week6');
		abot.scale.set(6, 6);
		abot.origin.x = Math.round(abot.origin.x);
		abot.origin.y = Math.round(abot.origin.y);
		abot.antialiasing = false;
		abot.animation.addByPrefix('danceLeft', 'danceLeft', 24, false);
		abot.animation.addByPrefix('danceRight', 'danceRight', 24, false);
		abot.animation.addByPrefix('lowerKnife', 'return', 24, false);
		add(abot);
		}
	}

	var lookingAtRight:Bool = true;
	public function lookLeft()
	{
		if(lookingAtRight) eyes.anim.play('lookleft', true);
		if(lookingAtRight && abotHead != null) abotHead.animation.play('toleft', true);
		eyes.anim.curInstance.matrix.tx = 562.9;
		eyes.anim.curInstance.matrix.ty = 731.2;
		lookingAtRight = false;
	}
	public function lookRight()
	{
		if(!lookingAtRight) eyes.anim.play('lookright', true);
		if(!lookingAtRight && abotHead != null) abotHead.animation.play('toright', true);
		eyes.anim.curInstance.matrix.tx = 562.9;
		eyes.anim.curInstance.matrix.ty = 731.2;
		lookingAtRight = true;
	}

	public function initAnalyzer()
	{
		@:privateAccess
		analyzer = new SpectralAnalyzer(snd._channel.__source, 7, 0.1, 40);
		analyzer.minDb = -65;
		analyzer.maxDb = -25;
		analyzer.maxFreq = 22000;
		analyzer.minFreq = 10;
	
		#if desktop
		analyzer.fftN = 256;
		#end
	}

	public function dumpSound():Void
	{
		analyzer = null;
	}

	var levelMax:Int = 0;
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var levels = (analyzer != null) ? analyzer.getLevels() : getDefaultLevels();
		var oldLevelMax = levelMax;
		levelMax = 0;
		for (i in 0...Std.int(Math.min(vizSprites.length, levels.length)))
		{
			var animFrame:Int = (FlxG.sound.volume == 0 || FlxG.sound.muted) ? 0 : Math.round(levels[i].value * 6);

			vizSprites[i].visible = animFrame > 0;

			animFrame -= 1;

			animFrame = Std.int(Math.abs(FlxMath.bound(animFrame, 0, 5) - 5));
		
			vizSprites[i].animation.curAnim.curFrame = animFrame;

			levelMax = Std.int(Math.max(levelMax, 5 - animFrame));
		}
	}

  static final BAR_COUNT:Int = 7;

  static function getDefaultLevels():Array<Bar>
  {
    var result:Array<Bar> = [];

    for (i in 0...BAR_COUNT)
    {
      result.push({value: 0, peak: 0.0});
    }

    return result;
  }
}
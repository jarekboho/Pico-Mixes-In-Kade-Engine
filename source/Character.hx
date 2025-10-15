package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.FlxCamera;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var cameraFocusPoint:FlxPoint = new FlxPoint(0, 0);

	public var cameraOffsets:Array<Float> = [0,0];

	public var canPlayOtherAnims:Bool = true;

	public var normalChar:FlxSprite;

	public var VULTURE_THRESHOLD = 0.25 * 2;

	public var currentState:Int = 0;

	public var MIN_BLINK_DELAY:Int = 3;
	public var MAX_BLINK_DELAY:Int = 7;
	public var blinkCountdown:Int = 3;

	public var animationFinished:Bool = false;

	public var originalPosition:FlxPoint = new FlxPoint(0, 0);

	public var isBloody:Bool = false;

	public var trainPassing:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('daddyDearest','shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24);
				animation.addByPrefix('singUP', 'singUP', 24);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 24);
				animation.addByPrefix('singDOWN', 'singDOWN', 24);
				animation.addByPrefix('singLEFT', 'singLEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'spooky-dark':
				tex = Paths.getSparrowAtlas('spooky_dark', 'week2');
				frames = tex;
				animation.addByPrefix('singUP', 'SingUP', 24, false);
				animation.addByPrefix('singDOWN', 'SingDOWN', 24, false);
				animation.addByPrefix('singLEFT', 'SingLEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'SingRIGHT', 24, false);
				animation.addByIndices('danceLeft', 'Idle', [1, 2, 3, 4, 5, 6, 7, 8], "", 24, false);
				animation.addByIndices('danceRight', 'Idle', [9, 10, 11, 12, 13, 14, 15, 16], "", 24, false);
				animation.addByPrefix('cheer', 'Cheer', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				addOffset("cheer");

				playAnim('danceRight');

				normalChar = new FlxSprite();
				normalChar.frames = Paths.getSparrowAtlas('SpookyKids', 'week2');
				normalChar.animation.addByPrefix('singUP', 'SingUP', 24, false);
				normalChar.animation.addByPrefix('singDOWN', 'SingDOWN', 24, false);
				normalChar.animation.addByPrefix('singLEFT', 'SingLEFT', 24, false);
				normalChar.animation.addByPrefix('singRIGHT', 'SingRIGHT', 24, false);
				normalChar.animation.addByIndices('danceLeft', 'Idle', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
				normalChar.animation.addByIndices('danceRight', 'Idle', [8, 9, 10, 11, 12, 13, 14, 15], "", 24, false);
				normalChar.animation.addByPrefix('cheer', 'Cheer', 24, false);
				normalChar.alpha = 0.00000001;
				normalChar.antialiasing = true;

			case 'pico':
				tex = Paths.getSparrowAtlas('Pico_Basic', 'weekend1');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);

				addOffset('idle');
				addOffset("singUP", -32, 28);
				addOffset("singRIGHT", -86, -10);
				addOffset("singLEFT", 61, 2);
				addOffset("singDOWN", -37, -82);

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND','shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', -37, 11);
				addOffset('deathLoop', -37, 5);
				addOffset('deathConfirm', -37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('weeb/senpai', 'week6');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", 0.83, 6.16);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 6.6, 0);
				addOffset("singDOWN", 2.33, 0);

				playAnim('idle');

				scale.set(6, 6);
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('weeb/senpai', 'week6');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE instance 10', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE instance 10', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE instance 10', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE instance 10', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", 0.83, 6.16);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 6.6, 0);
				addOffset("singDOWN", 2.33, 0);
				playAnim('idle');

				scale.set(6, 6);
				updateHitbox();

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('christmas/mom_dad_christmas_assets', 'week5');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');

			case 'tankman':
				var assetList = ['tankmanPico'];

				var texture:FlxAtlasFrames = Paths.getSparrowAtlas('tankmanCaptain', 'week7');

				if (texture == null)
				{
				trace('Multi-Sparrow atlas could not load PRIMARY texture: tankmanCaptain');
				}
				else
				{
				trace('Creating multi-sparrow atlas: tankmanCaptain');
				texture.parent.destroyOnNoUse = false;
				}

				for (asset in assetList)
				{
				var subTexture:FlxAtlasFrames = Paths.getSparrowAtlas(asset, 'week7');
				// If we don't do this, the unused textures will be removed as soon as they're loaded.

				if (subTexture == null)
				{
				trace('Multi-Sparrow atlas could not load subtexture: ${asset}');
				}
				else
				{
				trace('Concatenating multi-sparrow atlas: ${asset}');
				subTexture.parent.destroyOnNoUse = false;
				}

				texture.addAtlas(subTexture);
				}

				frames = texture;

				animation.addByPrefix('idle', 'Tankman Idle Dance instance 1', 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note instance 1', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Note Left instance 1', 24, false);
				animation.addByPrefix('hehPrettyGood', 'PRETTY GOOD tankman instance 1', 24, false);
				animation.addByPrefix('ugh', 'TANKMAN UGH instance 1', 24, false);
				animation.addByPrefix('laugh', 'tankman laugh', 24, false, true);
				animation.addByPrefix('beat it', 'tankman beat it', 24, false, true);
				animation.addByPrefix('augh', 'tankman ARGH', 24, false, true);

				addOffset('idle', 0, 0);
				addOffset("singUP", 48, 54);
				addOffset("singRIGHT", -22, -28);
				addOffset("singLEFT", 90, -13);
				addOffset("singDOWN", 63, -105);
				addOffset("hehPrettyGood", -2, 15);
				addOffset("ugh", -16, -9);
				addOffset("laugh", -18, 10);
				addOffset("beat it", 90, -9);
				addOffset("augh", 52, -6);

				playAnim('idle');

				flipX = true;

				globalOffsets[1] = -50;

			case 'tankman-bloody':
				var assetList = ['tankmanCaptainBloody'];

				var texture:FlxAtlasFrames = Paths.getSparrowAtlas('tankmanCaptain', 'week7');

				if (texture == null)
				{
				trace('Multi-Sparrow atlas could not load PRIMARY texture: tankmanCaptain');
				}
				else
				{
				trace('Creating multi-sparrow atlas: tankmanCaptain');
				texture.parent.destroyOnNoUse = false;
				}

				for (asset in assetList)
				{
				var subTexture:FlxAtlasFrames = Paths.getSparrowAtlas(asset, 'week7');
				// If we don't do this, the unused textures will be removed as soon as they're loaded.

				if (subTexture == null)
				{
				trace('Multi-Sparrow atlas could not load subtexture: ${asset}');
				}
				else
				{
				trace('Concatenating multi-sparrow atlas: ${asset}');
				subTexture.parent.destroyOnNoUse = false;
				}

				texture.addAtlas(subTexture);
				}

				frames = texture;

				animation.addByPrefix('idle', 'Tankman Idle Dance instance 1', 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note instance 1', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Note Left instance 1', 24, false);
				animation.addByPrefix('hehPrettyGood', 'PRETTY GOOD tankman instance 1', 24, false);
				animation.addByPrefix('ugh', 'TANKMAN UGH instance 1', 24, false);
				animation.addByPrefix('idle-bloody', 'Tankman Idle bloody0', 24, false);
				animation.addByPrefix('singUP-bloody', 'Tankman UP note bloody0', 24, false);
				animation.addByPrefix('singDOWN-bloody', 'Tankman DOWN note bloody0', 24, false);
				animation.addByPrefix('singLEFT-bloody', 'Tankman Right Note bloody0', 24, false);
				animation.addByPrefix('singRIGHT-bloody', 'Tankman Note Left bloody0', 24, false);
				animation.addByPrefix('redheadsAnim', 'redheads anim0', 24, false);
				animation.addByPrefix('hehPrettyGood-bloody', 'pretty good anim0', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", 48, 54);
				addOffset("singRIGHT", -22, -28);
				addOffset("singLEFT", 90, -13);
				addOffset("singDOWN", 63, -105);
				addOffset("hehPrettyGood", -2, 15);
				addOffset("ugh", -16, -9);
				addOffset('idle-bloody', 0, 52);
				addOffset("singUP-bloody", 47, 165);
				addOffset("singRIGHT-bloody", -23, 17);
				addOffset("singLEFT-bloody", 90, 15);
				addOffset("singDOWN-bloody", 62, -105);
				addOffset("redheadsAnim", 110, 117);
				addOffset("hehPrettyGood-bloody", 0, 90);

				playAnim('idle');

				flipX = true;

				globalOffsets[1] = -50;

			case 'pico-playable':
				var assetList = ['Pico_Playable', 'Pico_Shooting', 'Pico_Death', 'Pico_Intro', 'Pico_Censored', 'pico-cheer', 'pico-yeah', 'Pico_Burps'];

				var texture:FlxAtlasFrames = Paths.getSparrowAtlas('Pico_Basic', 'weekend1');

				if (texture == null)
				{
				trace('Multi-Sparrow atlas could not load PRIMARY texture: Pico_Basic');
				}
				else
				{
				trace('Creating multi-sparrow atlas: Pico_Basic');
				texture.parent.destroyOnNoUse = false;
				}

				for (asset in assetList)
				{
				var subTexture:FlxAtlasFrames = Paths.getSparrowAtlas(asset, 'weekend1');
				// If we don't do this, the unused textures will be removed as soon as they're loaded.

				if (subTexture == null)
				{
				trace('Multi-Sparrow atlas could not load subtexture: ${asset}');
				}
				else
				{
				trace('Concatenating multi-sparrow atlas: ${asset}');
				subTexture.parent.destroyOnNoUse = false;
				}

				texture.addAtlas(subTexture);
				}

				frames = texture;

				animation.addByPrefix('idle', 'Pico Idle Dance', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Left Note MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);
				animation.addByPrefix('singUPmiss', 'Pico Up Note MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico Right Note MISS', 24, false);
				animation.addByPrefix('shootMISS', 'Pico Hit Can0', 24, false);
animation.addByIndices('firstDeath', 'Pico Death Stab', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "", 24, false);
				animation.addByPrefix('firstDeathExplosion', 'Pico Idle Dance', 24, false);
				animation.addByIndices('deathLoop', 'Pico Death Stab', [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63], "", 24, true);
				animation.addByPrefix('cock', 'Pico Reload0', 24, false);
				animation.addByPrefix('shoot', 'Pico Shoot Hip Full0', 24, false);
				animation.addByPrefix('intro1', 'Pico Gets Pissed0', 24, false);
				animation.addByPrefix('cockCutscene', 'cutscene cock0', 24, false);
				animation.addByPrefix('intro2', 'shoot and return0', 24, false);
				animation.addByPrefix('singRIGHT-censor', 'pico swear right', 24, false);
				animation.addByPrefix('singDOWN-censor', 'pico swear down', 24, false);
				animation.addByPrefix('singUP-censor', 'pico swear up', 24, false);
				animation.addByPrefix('singLEFT-censor', 'pico swear left', 24, false);
				animation.addByPrefix('hey', 'Pico HEY!!0', 24, false);
				animation.addByPrefix('cheer', 'Pico YEAH cheer0', 24, false);
				animation.addByPrefix('burpShit', 'burpshit', 24, false);
				animation.addByPrefix('burpSmile', 'burpsmile', 24, false);
animation.addByIndices('burpSmileLong', 'burpsmile', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 25, 26, 27, 28, 29, 30, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31], "", 24, false);
				animation.addByPrefix('shit', 'shit', 24, false);

				addOffset('idle');
				addOffset("singRIGHT", -50, 1);
				addOffset("singDOWN", 84, -77);
				addOffset("singUP", 21, 28);
				addOffset("singLEFT", 84, -11);
				addOffset("singLEFTmiss", 68, 20);
				addOffset("singDOWNmiss", 80, -40);
				addOffset("singUPmiss", 29, 70);
				addOffset("singRIGHTmiss", -55, 45);
				addOffset("shootMISS", 0, 0);
				addOffset("firstDeath", 225, 125);
				addOffset("firstDeathExplosion", 225, 125);
				addOffset("deathLoop", 225, 125);
				addOffset("cock", 0, 0);
				addOffset("shoot", 300, 250);
				addOffset("intro1", 60, 0);
				addOffset("cockCutscene", 0, 0);
				addOffset("intro2", 260, 230);
				addOffset("singRIGHT-censor", -50, 1);
				addOffset("singDOWN-censor", 84, -77);
				addOffset("singUP-censor", 21, 28);
				addOffset("singLEFT-censor", 84, -11);
				addOffset("hey", 0, 0);
				addOffset("cheer", 0, 0);
				addOffset("burpShit", 33, -3);
				addOffset("burpSmile", 33, -3);
				addOffset("burpSmileLong", 33, -3);
				addOffset("shit", 0, -3);

				playAnim('idle');

				flipX = true;

			case 'pico-dark':
				var tex = Paths.getSparrowAtlas('pico_dark', 'week2');
				frames = tex;
				animation.addByPrefix('idle', 'Pico Idle Dance', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);
				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
				animation.addByPrefix('hey', 'Pico HEY!!0', 24, false);
				animation.addByPrefix('cheer', 'Pico YEAH cheer0', 24, false);
				animation.addByPrefix('burpShit', 'burpshit', 24, false);
				animation.addByPrefix('burpSmile', 'burpsmile', 24, false);
animation.addByIndices('burpSmileLong', 'burpsmile', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 25, 26, 27, 28, 29, 30, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31], "", 24, false);
				animation.addByPrefix('shit', 'shit', 24, false);

				addOffset('idle');
				addOffset("singRIGHT", -50, 1);
				addOffset("singDOWN", 84, -77);
				addOffset("singUP", 21, 28);
				addOffset("singLEFT", 84, -11);
				addOffset("singLEFTmiss", 68, 20);
				addOffset("singDOWNmiss", 80, -40);
				addOffset("singUPmiss", 29, 70);
				addOffset("singRIGHTmiss", -55, 45);
				addOffset("hey", 0, 0);
				addOffset("cheer", 0, 0);
				addOffset("burpShit", 33, -3);
				addOffset("burpSmile", 33, -3);
				addOffset("burpSmileLong", 33, -3);
				addOffset("shit", 33, -3);

				playAnim('idle');

				flipX = true;

				normalChar = new FlxSprite();

				var assetList = ['Pico_Playable', 'Pico_Shooting', 'Pico_Death', 'Pico_Intro', 'Pico_Censored', 'pico-cheer', 'pico-yeah', 'Pico_Burps'];

				var texture:FlxAtlasFrames = Paths.getSparrowAtlas('Pico_Basic', 'weekend1');

				if (texture == null)
				{
				trace('Multi-Sparrow atlas could not load PRIMARY texture: Pico_Basic');
				}
				else
				{
				trace('Creating multi-sparrow atlas: Pico_Basic');
				texture.parent.destroyOnNoUse = false;
				}

				for (asset in assetList)
				{
				var subTexture:FlxAtlasFrames = Paths.getSparrowAtlas(asset, 'weekend1');
				// If we don't do this, the unused textures will be removed as soon as they're loaded.

				if (subTexture == null)
				{
				trace('Multi-Sparrow atlas could not load subtexture: ${asset}');
				}
				else
				{
				trace('Concatenating multi-sparrow atlas: ${asset}');
				subTexture.parent.destroyOnNoUse = false;
				}

				texture.addAtlas(subTexture);
				}

				normalChar.frames = texture;

				normalChar.animation.addByPrefix('idle', 'Pico Idle Dance', 24, false);
				normalChar.animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				normalChar.animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				normalChar.animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				normalChar.animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
				normalChar.animation.addByPrefix('singLEFTmiss', 'Pico Left Note MISS', 24, false);
				normalChar.animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);
				normalChar.animation.addByPrefix('singUPmiss', 'Pico Up Note MISS', 24, false);
				normalChar.animation.addByPrefix('singRIGHTmiss', 'Pico Right Note MISS', 24, false);
				normalChar.animation.addByPrefix('shootMISS', 'Pico Hit Can0', 24, false);
normalChar.animation.addByIndices('firstDeath', 'Pico Death Stab', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "", 24, false);
				normalChar.animation.addByPrefix('firstDeathExplosion', 'Pico Idle Dance', 24, false);
				normalChar.animation.addByIndices('deathLoop', 'Pico Death Stab', [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63], "", 24, true);
				normalChar.animation.addByPrefix('cock', 'Pico Reload0', 24, false);
				normalChar.animation.addByPrefix('shoot', 'Pico Shoot Hip Full0', 24, false);
				normalChar.animation.addByPrefix('intro1', 'Pico Gets Pissed0', 24, false);
				normalChar.animation.addByPrefix('cockCutscene', 'cutscene cock0', 24, false);
				normalChar.animation.addByPrefix('intro2', 'shoot and return0', 24, false);
				normalChar.animation.addByPrefix('singRIGHT-censor', 'pico swear right', 24, false);
				normalChar.animation.addByPrefix('singDOWN-censor', 'pico swear down', 24, false);
				normalChar.animation.addByPrefix('singUP-censor', 'pico swear up', 24, false);
				normalChar.animation.addByPrefix('singLEFT-censor', 'pico swear left', 24, false);
				normalChar.animation.addByPrefix('hey', 'Pico HEY!!0', 24, false);
				normalChar.animation.addByPrefix('cheer', 'Pico YEAH cheer0', 24, false);
				normalChar.animation.addByPrefix('burpShit', 'burpshit', 24, false);
				normalChar.animation.addByPrefix('burpSmile', 'burpsmile', 24, false);
normalChar.animation.addByIndices('burpSmileLong', 'burpsmile', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 25, 26, 27, 28, 29, 30, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31], "", 24, false);
				normalChar.animation.addByPrefix('shit', 'shit', 24, false);
				normalChar.alpha = 0.00000001;
				normalChar.antialiasing = true;

			case 'pico-christmas':
				var assetList = ['christmas/picoChristmas/picoChristmasDeath'];

				var texture:FlxAtlasFrames = Paths.getSparrowAtlas('christmas/picoChristmas/picoChristmas', 'week5');

				if (texture == null)
				{
				trace('Multi-Sparrow atlas could not load PRIMARY texture: christmas/picoChristmas/picoChristmas');
				}
				else
				{
				trace('Creating multi-sparrow atlas: christmas/picoChristmas/picoChristmas');
				texture.parent.destroyOnNoUse = false;
				}

				for (asset in assetList)
				{
				var subTexture:FlxAtlasFrames = Paths.getSparrowAtlas(asset, 'week5');
				// If we don't do this, the unused textures will be removed as soon as they're loaded.

				if (subTexture == null)
				{
				trace('Multi-Sparrow atlas could not load subtexture: ${asset}');
				}
				else
				{
				trace('Concatenating multi-sparrow atlas: ${asset}');
				subTexture.parent.destroyOnNoUse = false;
				}

				texture.addAtlas(subTexture);
				}

				frames = texture;

				animation.addByPrefix('idle', 'Pico Idle Dance xmas0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico Note Right xmas0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note xmas0', 24, false);
				animation.addByPrefix('singUP', 'pico Up note xmas0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico NOTE LEFT xmas0', 24, false);
			animation.addByIndices('singLEFTmiss', 'Pico NOTE LEFT miss xmas0', [1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], "", 24, false);
			animation.addByIndices('singDOWNmiss', 'Pico Down Note MISS xmas0', [1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], "", 24, false);
			animation.addByIndices('singUPmiss', 'pico Up note miss xmas0', [1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], "", 24, false);
			animation.addByIndices('singRIGHTmiss', 'Pico Note Right Miss xmas0', [1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], "", 24, false);
animation.addByIndices('firstDeath', 'DEATH PICO xmas0', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], "", 24, false);
				animation.addByIndices('deathLoop', 'DEATH PICO xmas0', [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63], "", 24, true);

				addOffset('idle');
				addOffset("singRIGHT", -65, 1);
				addOffset("singDOWN", 84, -77);
				addOffset("singUP", 31, 28);
				addOffset("singLEFT", 90, -11);
				addOffset("singLEFTmiss", 68, 20);
				addOffset("singDOWNmiss", 80, -40);
				addOffset("singUPmiss", 29, 60);
				addOffset("singRIGHTmiss", -55, 45);
				addOffset("firstDeath", 225, 125);
				addOffset("deathLoop", 225, 125);

				playAnim('idle');

				flipX = true;

			case 'pico-pixel':
				frames = Paths.getSparrowAtlas('weeb/picoPixel/picoPixel', 'week6');
				animation.addByPrefix('idle', 'idle0', 24, false);
				animation.addByPrefix('singUP', 'up0', 24, false);
				animation.addByPrefix('singLEFT', 'left0', 24, false);
				animation.addByPrefix('singRIGHT', 'right0', 24, false);
				animation.addByPrefix('singDOWN', 'down0', 24, false);
				animation.addByPrefix('singUPmiss', 'upmiss0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'leftmiss0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'rightmiss0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'downmiss0', 24, false);
				animation.addByPrefix('firstDeath', "firstDeath0", 24, false);
				animation.addByPrefix('deathLoop', "deathLoop0", 24, true);
				animation.addByPrefix('deathConfirm', "deathConfirm0", 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");
				addOffset('firstDeath');
				addOffset('deathLoop');
				addOffset('deathConfirm');

				scale.set(6, 6);
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

				flipX = true;

				PauseSubState.musicSuffix = '-pixel';

			case 'pico-holding-nene':
				frames = Paths.getSparrowAtlas('picoAndNene', 'week7');
				animation.addByPrefix('idle', 'Pico Idle Dance', 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singUPmiss', 'note miss up piconene0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'note miss left pico nene0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'note miss right pico nene0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'note miss down pico nene0', 24, false);
				animation.addByPrefix('knifeToss', 'pico nene knife toss0', 24, false);
				animation.addByPrefix('laughEnd', 'pico nene laughing full0', 24, false);
				animation.addByPrefix('firstDeath', "", 24, false);

				addOffset('idle');
				addOffset("singUP", 56, 3);
				addOffset("singRIGHT", -48, -20);
				addOffset("singLEFT", 27, -16);
				addOffset("singDOWN", 93, -70);
				addOffset("singUPmiss", 60, 2);
				addOffset("singRIGHTmiss", -45, -19);
				addOffset("singLEFTmiss", 28, -11);
				addOffset("singDOWNmiss", 95, -74);
				addOffset('knifeToss', 14, 26);
				addOffset('laughEnd', 5, 7);
				addOffset('firstDeath');

				playAnim('idle');

				flipX = true;

				globalOffsets[0] = 20;
				globalOffsets[1] = 2;

			case 'nene':
				var assetList = ['Nene_Hair_Blowing'];

				var texture:FlxAtlasFrames = Paths.getSparrowAtlas('Nene', 'weekend1');

				if (texture == null)
				{
				trace('Multi-Sparrow atlas could not load PRIMARY texture: Nene');
				}
				else
				{
				trace('Creating multi-sparrow atlas: Nene');
				texture.parent.destroyOnNoUse = false;
				}

				for (asset in assetList)
				{
				var subTexture:FlxAtlasFrames = Paths.getSparrowAtlas(asset, 'weekend1');
				// If we don't do this, the unused textures will be removed as soon as they're loaded.

				if (subTexture == null)
				{
				trace('Multi-Sparrow atlas could not load subtexture: ${asset}');
				}
				else
				{
				trace('Concatenating multi-sparrow atlas: ${asset}');
				subTexture.parent.destroyOnNoUse = false;
				}

				texture.addAtlas(subTexture);
				}

				frames = texture;

				animation.addByIndices('danceLeft', 'Idle0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Idle0', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('combo50', 'ComboCheer0', 24, false);
animation.addByIndices('drop70', 'Laugh0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11], "", 24, false);
animation.addByIndices('laughCutscene', 'Laugh0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByIndices('combo200', 'ComboFawn0', [0, 1, 2, 3, 4, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6], "", 24, false);
				animation.addByPrefix('raiseKnife', 'KnifeRaise0', 24, false);
				animation.addByPrefix('idleKnife', 'KnifeIdle0', 24, false);
				animation.addByPrefix('lowerKnife', 'KnifeLower0', 24, false);
				animation.addByIndices('hairBlowNormal', 'HairBlow0', [0, 1, 2, 3, 0, 1, 2, 3], "", 24, false);
				animation.addByIndices('hairFallNormal', 'HairBlow0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], "", 24, false);
				animation.addByIndices('hairBlowKnife', 'HairBlowKnife0', [0, 1, 2, 3, 0, 1, 2, 3], "", 24, false);
				animation.addByIndices('hairFallKnife', 'HairBlowKnife0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');
				addOffset('combo50', -120, 50);
				addOffset('drop70');
				addOffset('laughCutscene');
				addOffset('combo200', -50, -25);
				addOffset('raiseKnife', 0, 52);
				addOffset('idleKnife', -99, 52);
				addOffset('lowerKnife', 135, 52);
				addOffset('hairBlowNormal', 0, 0);
				addOffset('hairFallNormal', 0, 0);
				addOffset('hairBlowKnife', -79, 51);
				addOffset('hairFallKnife', -79, 51);

				playAnim('danceRight');

				globalOffsets[1] = -100;

			case 'nene-dark':
				frames = Paths.getSparrowAtlas('nene_dark', 'week2');
				animation.addByIndices('danceLeft', 'Nene Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Nene Idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('combo50', 'combo celebration 1 nene', 24, false);
animation.addByIndices('drop70', 'laughing nene', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11], "", 24, false);
animation.addByIndices('laughCutscene', 'laughing nene', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByIndices('combo200', 'fawn nene', [0, 1, 2, 3, 4, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6], "", 24, false);
				animation.addByPrefix('raiseKnife', 'knife raise', 24, false);
				animation.addByPrefix('idleKnife', 'knife high held', 24, false);
				animation.addByPrefix('lowerKnife', 'knife lower', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');
				addOffset('combo50', -120, 50);
				addOffset('drop70');
				addOffset('laughCutscene');
				addOffset('combo200', -50, -25);
				addOffset('raiseKnife', 0, 10);
				addOffset('idleKnife', -19, 10);
				addOffset('lowerKnife', 0, 10);

				playAnim('danceRight');

				globalOffsets[1] = -100;

				normalChar = new FlxSprite();

				var assetList = ['Nene_Hair_Blowing'];

				var texture:FlxAtlasFrames = Paths.getSparrowAtlas('Nene', 'weekend1');

				if (texture == null)
				{
				trace('Multi-Sparrow atlas could not load PRIMARY texture: Nene');
				}
				else
				{
				trace('Creating multi-sparrow atlas: Nene');
				texture.parent.destroyOnNoUse = false;
				}

				for (asset in assetList)
				{
				var subTexture:FlxAtlasFrames = Paths.getSparrowAtlas(asset, 'weekend1');
				// If we don't do this, the unused textures will be removed as soon as they're loaded.

				if (subTexture == null)
				{
				trace('Multi-Sparrow atlas could not load subtexture: ${asset}');
				}
				else
				{
				trace('Concatenating multi-sparrow atlas: ${asset}');
				subTexture.parent.destroyOnNoUse = false;
				}

				texture.addAtlas(subTexture);
				}

				normalChar.frames = Paths.getSparrowAtlas('Nene', 'weekend1');

				normalChar.animation.addByIndices('danceLeft', 'Idle0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				normalChar.animation.addByIndices('danceRight', 'Idle0', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				normalChar.animation.addByPrefix('combo50', 'ComboCheer0', 24, false);
normalChar.animation.addByIndices('drop70', 'Laugh0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11], "", 24, false);
normalChar.animation.addByIndices('laughCutscene', 'Laugh0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11], "", 24, false);
		normalChar.animation.addByIndices('combo200', 'ComboFawn0', [0, 1, 2, 3, 4, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6], "", 24, false);
				normalChar.animation.addByPrefix('raiseKnife', 'KnifeRaise0', 24, false);
				normalChar.animation.addByPrefix('idleKnife', 'KnifeIdle0', 24, false);
				normalChar.animation.addByPrefix('lowerKnife', 'KnifeLower0', 24, false);
				normalChar.animation.addByIndices('hairBlowNormal', 'HairBlow0', [0, 1, 2, 3, 0, 1, 2, 3], "", 24, false);
				normalChar.animation.addByIndices('hairFallNormal', 'HairBlow0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], "", 24, false);
				normalChar.animation.addByIndices('hairBlowKnife', 'HairBlowKnife0', [0, 1, 2, 3, 0, 1, 2, 3], "", 24, false);
				normalChar.animation.addByIndices('hairFallKnife', 'HairBlowKnife0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				normalChar.alpha = 0.00000001;
				normalChar.antialiasing = true;

			case 'nene-christmas':
				frames = Paths.getSparrowAtlas('christmas/neneChristmas/neneChristmas', 'week5');
				animation.addByIndices('danceLeft', 'Nene Abot Idle xmas0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Nene Abot Idle xmas0', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('combo50', 'combo celebration 1 nene xmas0', 24, false);
animation.addByIndices('drop70', 'laughing nene', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByIndices('combo200', 'fawn nene xmas0', [0, 1, 2, 3, 4, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6], "", 24, false);
				animation.addByPrefix('raiseKnife', 'knife raise xmas0', 24, false);
				animation.addByPrefix('idleKnife', 'knife high held xmas0', 24, false);
				animation.addByPrefix('lowerKnife', 'knife lower xmas0', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');
				addOffset('combo50', -120, 50);
				addOffset('drop70');
				addOffset('combo200', -50, -25);
				addOffset('raiseKnife', 0, 52);
				addOffset('idleKnife', -99, 52);
				addOffset('lowerKnife', 135, 52);

				playAnim('danceRight');

				globalOffsets[1] = -100;

			case 'nene-pixel':
				frames = Paths.getSparrowAtlas('weeb/nenePixel/nenePixel', 'week6');
				animation.addByIndices('danceLeft', 'idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24, false);
				animation.addByIndices('danceRight', 'idle', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 24, false);
				animation.addByPrefix('raiseKnife', 'raise', 24, false);
				animation.addByIndices('idleKnife', 'blink', [6, 7], "", 24, false);
				animation.addByIndices('idleKnifeBlink', 'blink', [0, 1, 2, 3, 4, 5], "", 24, false);
				animation.addByIndices('lowerKnife', 'lower', [0, 1, 2, 3, 4, 5], "", 24, false);

				addOffset('danceLeft');
				addOffset("danceRight");
				addOffset("raiseKnife", 0, 10);
				addOffset("idleKnife", 0, 10);
				addOffset("idleKnifeBlink", -19, 10);
				addOffset("lowerKnife", 0, 10);

				scale.set(6, 6);
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'nene-tankmen':
				var assetList = ['Nene_Hair_Blowing'];

				var texture:FlxAtlasFrames = Paths.getSparrowAtlas('Nene', 'weekend1');

				if (texture == null)
				{
				trace('Multi-Sparrow atlas could not load PRIMARY texture: Nene');
				}
				else
				{
				trace('Creating multi-sparrow atlas: Nene');
				texture.parent.destroyOnNoUse = false;
				}

				for (asset in assetList)
				{
				var subTexture:FlxAtlasFrames = Paths.getSparrowAtlas(asset, 'weekend1');
				// If we don't do this, the unused textures will be removed as soon as they're loaded.

				if (subTexture == null)
				{
				trace('Multi-Sparrow atlas could not load subtexture: ${asset}');
				}
				else
				{
				trace('Concatenating multi-sparrow atlas: ${asset}');
				subTexture.parent.destroyOnNoUse = false;
				}

				texture.addAtlas(subTexture);
				}

				frames = texture;

				animation.addByIndices('danceLeft', 'Idle0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Idle0', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('combo50', 'ComboCheer0', 24, false);
animation.addByIndices('drop70', 'Laugh0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11], "", 24, false);
animation.addByIndices('laughCutscene', 'Laugh0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByIndices('combo200', 'ComboFawn0', [0, 1, 2, 3, 4, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6], "", 24, false);
				animation.addByPrefix('raiseKnife', 'KnifeRaise0', 24, false);
				animation.addByPrefix('idleKnife', 'KnifeIdle0', 24, false);
				animation.addByPrefix('lowerKnife', 'KnifeLower0', 24, false);
				animation.addByIndices('hairBlowNormal', 'HairBlow0', [0, 1, 2, 3, 0, 1, 2, 3], "", 24, false);
				animation.addByIndices('hairFallNormal', 'HairBlow0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], "", 24, false);
				animation.addByIndices('hairBlowKnife', 'HairBlowKnife0', [0, 1, 2, 3, 0, 1, 2, 3], "", 24, false);
				animation.addByIndices('hairFallKnife', 'HairBlowKnife0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');
				addOffset('combo50', -120, 50);
				addOffset('drop70');
				addOffset('laughCutscene');
				addOffset('combo200', -50, -25);
				addOffset('raiseKnife', 0, 52);
				addOffset('idleKnife', -99, 52);
				addOffset('lowerKnife', 135, 52);
				addOffset('hairBlowNormal', 0, 0);
				addOffset('hairFallNormal', 0, 0);
				addOffset('hairBlowKnife', -79, 51);
				addOffset('hairFallKnife', -79, 51);

				playAnim('danceRight');

				globalOffsets[0] = -30;
				globalOffsets[1] = -84;

			case 'otis-speaker':
				frames = Paths.getSparrowAtlas('otisSpeaker', 'week7');
				animation.addByPrefix('idle', 'otis idle0', 24, false);
				animation.addByPrefix('shoot1', 'shoot back0', 24, false);
				animation.addByPrefix('shoot2', 'shoot back low0', 24, false);
				animation.addByPrefix('shoot3', 'shoot forward0', 24, false);
				animation.addByPrefix('shoot4', 'shoot forward low0', 24, false);

				addOffset('idle');
				addOffset('shoot1', 0, 13);
				addOffset('shoot2', -35, 21);
				addOffset('shoot3', 238, 96);
				addOffset('shoot4', 260, 23);

				playAnim('idle');

				globalOffsets[0] = -40;
				globalOffsets[1] = -135;
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
if (!curCharacter.startsWith('bf') && curCharacter != 'pico-playable' && curCharacter != 'pico-dark' && curCharacter != 'pico-christmas' && curCharacter != 'pico-pixel' && curCharacter != 'pico-holding-nene')
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
if (!curCharacter.startsWith('bf') && curCharacter != 'pico-playable' && curCharacter != 'pico-dark' && curCharacter != 'pico-christmas' && curCharacter != 'pico-pixel' && curCharacter != 'pico-holding-nene')
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 8.0;

			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					dance();
		}

		if (animation.curAnim.finished)
		{
		if (!canPlayOtherAnims && !debugMode)
		{
		canPlayOtherAnims = true;
		}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'nene':
					// Then, perform the appropriate animation for the current state.
					switch(currentState) {
					case 0:
						if (danced) {
						playAnim('danceRight');
						} else {
						playAnim('danceLeft');
						}
						danced = !danced;
					case 1:
						playAnim('danceLeft', false);
						danced = false;
					case 3:
						if (blinkCountdown == 0) {
						playAnim('idleKnife', false);
						blinkCountdown = FlxG.random.int(MIN_BLINK_DELAY, MAX_BLINK_DELAY);
						} else {
						blinkCountdown--;
						}
					case 4:
						if(animation.curAnim.name != 'lowerKnife'){
						playAnim('lowerKnife');
						}
					default:
						// In other states, don't interrupt the existing animation.
					}
				case 'nene-dark':
					// Then, perform the appropriate animation for the current state.
					switch(currentState) {
					case 0:
						if (danced) {
						playAnim('danceRight');
						} else {
						playAnim('danceLeft');
						}
						danced = !danced;
					case 1:
						playAnim('danceLeft', false);
						danced = false;
					case 3:
						if (blinkCountdown == 0) {
						playAnim('idleKnife', false);
						blinkCountdown = FlxG.random.int(MIN_BLINK_DELAY, MAX_BLINK_DELAY);
						} else {
						blinkCountdown--;
						}
					case 4:
						if(animation.curAnim.name != 'lowerKnife'){
						playAnim('lowerKnife');
						}
					default:
						// In other states, don't interrupt the existing animation.
					}
				case 'nene-christmas':
					// Then, perform the appropriate animation for the current state.
					switch(currentState) {
					case 0:
						if (danced) {
						playAnim('danceRight');
						} else {
						playAnim('danceLeft');
						}
						danced = !danced;
					case 1:
						playAnim('danceLeft', false);
						danced = false;
					case 3:
						if (blinkCountdown == 0) {
						playAnim('idleKnife', false);
						blinkCountdown = FlxG.random.int(MIN_BLINK_DELAY, MAX_BLINK_DELAY);
						} else {
						blinkCountdown--;
						}
					case 4:
						if(animation.curAnim.name != 'lowerKnife'){
						playAnim('lowerKnife');
						}
					default:
						// In other states, don't interrupt the existing animation.
					}
				case 'nene-pixel':
					// Then, perform the appropriate animation for the current state.
					switch(currentState) {
					case 0:
						if (danced) {
						playAnim('danceRight');
						} else {
						playAnim('danceLeft');
						}
						danced = !danced;
					case 1:
						playAnim('danceLeft', false);
						danced = false;
					case 3:
						if (blinkCountdown == 0) {
						playAnim('idleKnifeBlink', false);
						blinkCountdown = FlxG.random.int(MIN_BLINK_DELAY, MAX_BLINK_DELAY);
						} else {
						blinkCountdown--;
						}
					default:
						// In other states, don't interrupt the existing animation.
					}
				case 'nene-tankmen':
					// Then, perform the appropriate animation for the current state.
					switch(currentState) {
					case 0:
						if (danced) {
						playAnim('danceRight');
						} else {
						playAnim('danceLeft');
						}
						danced = !danced;
					case 1:
						playAnim('danceLeft', false);
						danced = false;
					case 3:
						if (blinkCountdown == 0) {
						playAnim('idleKnife', false);
						blinkCountdown = FlxG.random.int(MIN_BLINK_DELAY, MAX_BLINK_DELAY);
						} else {
						blinkCountdown--;
						}
					case 4:
						if(animation.curAnim.name != 'lowerKnife'){
						playAnim('lowerKnife');
						}
					default:
						// In other states, don't interrupt the existing animation.
					}
				case 'spooky-dark':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

  var animOffsets2(default, set):Array<Float> = [0, 0];

  function set_animOffsets2(value:Array<Float>):Array<Float>
  {
    if (animOffsets2 == null) animOffsets2 = [0, 0];
    if ((animOffsets2[0] == value[0]) && (animOffsets2[1] == value[1])) return value;

    return animOffsets2 = value;
  }

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (!canPlayOtherAnims) return;
		if(isBloody)
		AnimName += '-bloody';
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			animOffsets2 = [daOffset[0],daOffset[1]];
		}
		else
			animOffsets2 = [0,0];

		if(normalChar != null){
		normalChar.animation.play(AnimName, Force, Reversed, Frame);
		normalChar.setPosition(this.x + globalOffsets[0], this.y + globalOffsets[1]);
		normalChar.offset.set(animOffsets2[0], animOffsets2[1]);
		}

		if (AnimName == 'redheadsAnim') isBloody = true;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

  public var characterOrigin(get, never):FlxPoint;

  function get_characterOrigin():FlxPoint
  {
    var xPos = (width / 2); // Horizontal center
    var yPos = (height); // Vertical bottom
    return new FlxPoint(xPos, yPos);
  }

  public var globalOffsets(default, set):Array<Float> = [0, 0];

  function set_globalOffsets(value:Array<Float>):Array<Float>
  {
    if (globalOffsets == null) globalOffsets = [0, 0];
    if (globalOffsets == value) return value;

    return globalOffsets = value;
  }

  // override getScreenPosition (used by FlxSprite's draw method) to account for animation offsets.
  override function getScreenPosition(?result:FlxPoint, ?camera:FlxCamera):FlxPoint
  {
    var output:FlxPoint = super.getScreenPosition(result, camera);
    output.x -= (animOffsets2[0] - globalOffsets[0]) * this.scale.x;
    output.y -= (animOffsets2[1] - globalOffsets[1]) * this.scale.y;
    return output;
  }

  public function resetCameraFocusPoint():Void
  {
    // Calculate the camera focus point
    var charCenterX = this.x + this.width / 2;
    var charCenterY = this.y + this.height / 2;
    this.cameraFocusPoint = new FlxPoint(charCenterX + cameraOffsets[0], charCenterY + cameraOffsets[1]);
  }

	override function set_alpha(val:Float):Float{
		super.set_alpha(val);
		if(normalChar != null)
		{
		if(val != 1)
			normalChar.alpha = 1;
		else
			normalChar.alpha = 0.0001;
		}

		return val;
	}
}
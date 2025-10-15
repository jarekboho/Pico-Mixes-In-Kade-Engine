package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitLeftB:FlxSprite;
	var portraitMiddle:FlxSprite;
	var portraitMiddleP:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitRightP:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var musicStopped = false;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 20);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(120, 120);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/portrait-senpai');
		portraitLeft.animation.addByPrefix('enter', 'portraitEnter0', 12, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitLeftB = new FlxSprite(120, 120);
		portraitLeftB.frames = Paths.getSparrowAtlas('weeb/portrait-senpai-bwuh');
		portraitLeftB.animation.addByPrefix('enter', 'portraitEnter0', 12, false);
		portraitLeftB.animation.addByPrefix('talk', 'portraitTalk0', 12, false);
		portraitLeftB.setGraphicSize(Std.int(portraitLeftB.width * PlayState.daPixelZoom * 0.9));
		portraitLeftB.updateHitbox();
		portraitLeftB.scrollFactor.set();
		add(portraitLeftB);
		portraitLeftB.visible = false;

		portraitMiddle = new FlxSprite(800, 180);
		portraitMiddle.frames = Paths.getSparrowAtlas('weeb/portrait-nene');
		portraitMiddle.animation.addByPrefix('enter', 'portraitEnter0', 12, false);
		portraitMiddle.setGraphicSize(Std.int(portraitMiddle.width * PlayState.daPixelZoom * 0.9));
		portraitMiddle.updateHitbox();
		portraitMiddle.scrollFactor.set();
		add(portraitMiddle);
		portraitMiddle.visible = false;

		portraitMiddleP = new FlxSprite(800, 120);
		portraitMiddleP.frames = Paths.getSparrowAtlas('weeb/portrait-nene-peeved');
		portraitMiddleP.animation.addByPrefix('enter', 'portraitEnter0', 12, false);
		portraitMiddleP.setGraphicSize(Std.int(portraitMiddleP.width * PlayState.daPixelZoom * 0.9));
		portraitMiddleP.updateHitbox();
		portraitMiddleP.scrollFactor.set();
		add(portraitMiddleP);
		portraitMiddleP.visible = false;

		portraitRight = new FlxSprite(800, 160);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/portrait-pico');
		portraitRight.animation.addByPrefix('enter', 'portraitEnter0', 12, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		portraitRightP = new FlxSprite(800, 120);
		portraitRightP.frames = Paths.getSparrowAtlas('weeb/portrait-pico-peeved');
		portraitRightP.animation.addByPrefix('enter', 'portraitEnter0', 12, false);
		portraitRightP.setGraphicSize(Std.int(portraitRightP.width * PlayState.daPixelZoom * 0.9));
		portraitRightP.updateHitbox();
		portraitRightP.scrollFactor.set();
		add(portraitRightP);
		portraitRightP.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(227, 452, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(225, 450, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitLeftB.visible = false;
						portraitMiddle.visible = false;
						portraitMiddleP.visible = false;
						portraitRight.visible = false;
						portraitRightP.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitLeftB.visible = false;
				portraitMiddle.visible = false;
				portraitMiddleP.visible = false;
				portraitRight.visible = false;
				portraitRightP.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					if (musicStopped)
					{
					musicStopped = false;
					FlxG.sound.music.resume();
					FlxG.sound.music.volume = 0.0;
					FlxTween.tween(FlxG.sound.music, {volume: 1.0}, 2.0, {ease: FlxEase.linear});
					}
				}
				if (PlayState.SONG.song.toLowerCase() == 'roses')
				portraitLeft.visible = false;
			case 'dadb':
				portraitLeft.visible = false;
				portraitMiddle.visible = false;
				portraitMiddleP.visible = false;
				portraitRight.visible = false;
				portraitRightP.visible = false;
				if (!portraitLeftB.visible)
				{
					portraitLeftB.visible = true;
					portraitLeftB.animation.play('talk');
					musicStopped = true;
					FlxG.sound.music.pause();
				}
			case 'gf':
				portraitLeft.visible = false;
				portraitLeftB.visible = false;
				portraitMiddleP.visible = false;
				portraitRight.visible = false;
				portraitRightP.visible = false;
				if (!portraitMiddle.visible)
				{
					portraitMiddle.visible = true;
					portraitMiddle.animation.play('enter');
				}
			case 'gfp':
				portraitLeft.visible = false;
				portraitLeftB.visible = false;
				portraitMiddle.visible = false;
				portraitRight.visible = false;
				portraitRightP.visible = false;
				if (!portraitMiddleP.visible)
				{
					portraitMiddleP.visible = true;
					portraitMiddleP.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				portraitLeftB.visible = false;
				portraitMiddle.visible = false;
				portraitMiddleP.visible = false;
				portraitRightP.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'bfp':
				portraitLeft.visible = false;
				portraitLeftB.visible = false;
				portraitMiddle.visible = false;
				portraitMiddleP.visible = false;
				portraitRight.visible = false;
				if (!portraitRightP.visible)
				{
					portraitRightP.visible = true;
					portraitRightP.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
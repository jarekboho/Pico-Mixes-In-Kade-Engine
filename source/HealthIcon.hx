package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('spooky-dark', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('tankman', [6, 7], 0, false, isPlayer);
		animation.add('tankman-bloody', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [21, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
		animation.add('pico-playable', [4, 5], 0, false, isPlayer);
		animation.add('pico-dark', [4, 5], 0, false, isPlayer);
		animation.add('pico-christmas', [4, 5], 0, false, isPlayer);
		animation.add('pico-pixel', [19, 20], 0, false, isPlayer);
		animation.add('pico-holding-nene', [4, 5], 0, false, isPlayer);
		animation.add('nene', [10, 11], 0, false, isPlayer);
		animation.add('nene-dark', [10, 11], 0, false, isPlayer);
		animation.add('nene-christmas', [10, 11], 0, false, isPlayer);
		animation.add('nene-pixel', [10, 11], 0, false, isPlayer);
		if(char == 'tankman-bloody')
		char = 'tankman';
		animation.play(char);
		switch(char){
			case 'pico-pixel' | 'senpai' | 'senpai-angry' | 'nene-pixel':
				{

				}
			default:
				{
					antialiasing = true;
				}
		}
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
package;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxSort;
import Lambda;

class TankmanSpriteGroup extends FlxTypedSpriteGroup<TankmanSprite>
{
  var tankmanTimes:Array<Float> = [];
  var tankmanDirs:Array<Bool> = [];

  var isErect:Bool = false;

  public function new(erect:Bool)
  {
    super(0, 0, 4);

    this.isErect = erect;
    trace('Initializing TankmanSpriteGroup... ' + (this.isErect ? ' (erect)' : ' (base)'));
  }

  public function isValid():Bool
  {
    return group != null;
  }

  public function initTimemap()
  {
    trace('Initializing Tankman timings...');
    tankmanTimes = [];
    // The tankmen's timings and directions are determined
    // by the chart, specifically the internal "picospeaker" difficulty.
    var animChart = Song.loadFromJson('picospeaker', 'stress');
    if (animChart == null)
    {
      trace('Skip initializing TankmanSpriteGroup: no picospeaker chart.');
      return;
    }
    else
    {
      trace('Found picospeaker chart for TankmanSpriteGroup.');
    }
    var animNotes:Array<Dynamic> = [];
    for (section in animChart.notes)
    {
    for (note in section.sectionNotes)
    {
    animNotes.push(note);
    }
    }

    // turns out sorting functions are completely useless in polymod right now and do nothing
    // i had to sort the whole pico chart by hand im gonna go insane
    animNotes.sort(function(a, b):Int {
      return FlxSort.byValues(FlxSort.ASCENDING, a[0], b[0]);
    });

    for (note in animNotes)
    {
      // Only one out of every 16 notes, on average, is a tankman.
      if (FlxG.random.bool(1 / 16 * 100))
      {
        tankmanTimes.push(note[0]);
        var goingRight:Bool = (note[1] % 4 == 2 || note[1] % 4 == 3) ? false : true;
        tankmanDirs.push(goingRight);
      }
    }
  }

  /**
   * Creates a Tankman sprite and adds it to the group.
   */
  function createTankman(initX:Float, initY:Float, strumTime:Float, goingRight:Bool, scale:Float)
  {
    // recycle() is neat; it looks for a sprite which has completed its animation and resets it,
    // rather than calling the constructor again. It only calls the constructor if it can't find one.

    var tankman:TankmanSprite = group.recycle(TankmanSprite);

    // We can directly set values which are defined by the script's superclass.
    tankman.x = initX;
    tankman.y = initY;
    tankman.scale.set(scale, scale);
    tankman.flipX = !goingRight;
    // We need to use scriptSet for values which were defined in a script.
    tankman.strumTime = strumTime;
    tankman.endingOffset = FlxG.random.float(50, 200);
    tankman.runSpeed = FlxG.random.float(0.6, 1);
    tankman.goingRight = goingRight;

    if (isErect)
    {
      tankman.addRimlight();
    }

    this.add(tankman);
  }

  var timer:Float = 0;

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    while (true)
    {
      // Create tankmen 10 seconds in advance.
      var cutoff:Float = Conductor.songPosition + (1000 * 3);
      if (tankmanTimes.length > 0 && tankmanTimes[0] <= cutoff)
      {
        var nextTime:Float = tankmanTimes.shift();
        var goingRight:Bool = tankmanDirs.shift();
        var xPos = 500;
        var yPos:Float = isErect ? 350 : (200 + FlxG.random.int(50, 100));
        var scale:Float = isErect ? 1.10 : 1.0;
        createTankman(FlxG.width * 0.74, yPos, nextTime, goingRight, scale);
      }
      else
      {
        break;
      }
    }
  }

  override function kill()
  {
    super.kill();
    tankmanTimes = [];
  }
}
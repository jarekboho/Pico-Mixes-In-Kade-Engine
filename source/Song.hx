package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef SongEventDataRaw =
{
	var t:Float;
	var e:String;
	var v:Dynamic;
}

class SongEventData
{
  public var time(default, set):Float;

  function set_time(value:Float):Float
  {
    _stepTime = null;
    return time = value;
  }

  public var eventKind:String;

  public var value:Dynamic = null;

  public var activated:Bool = false;

  public function new(time:Float, eventKind:String, value:Dynamic = null)
  {
    this.time = time;
    this.eventKind = eventKind;
    this.value = value;
  }

  var _stepTime:Null<Float> = null;

  public function getStepTime(force:Bool = false):Float
  {
    if (_stepTime != null && !force) return _stepTime;

    return _stepTime = Math.floor(this.time / Conductor.stepCrochet);
  }

  public function getDynamic(key:String):Null<Dynamic>
  {
    return this.value == null ? null : Reflect.field(this.value, key);
  }

  public function getBool(key:String):Null<Bool>
  {
    return this.value == null ? null : cast Reflect.field(this.value, key);
  }

  public function getInt(key:String):Null<Int>
  {
    if (this.value == null) return null;
    var result = Reflect.field(this.value, key);
    if (result == null) return null;
    if (Std.isOfType(result, Int)) return result;
    if (Std.isOfType(result, String)) return Std.parseInt(cast result);
    return cast result;
  }

  public function getFloat(key:String):Null<Float>
  {
    if (this.value == null) return null;
    var result = Reflect.field(this.value, key);
    if (result == null) return null;
    if (Std.isOfType(result, Float)) return result;
    if (Std.isOfType(result, String)) return Std.parseFloat(cast result);
    return cast result;
  }

  public function getString(key:String):String
  {
    return this.value == null ? null : cast Reflect.field(this.value, key);
  }

  public function getArray(key:String):Array<Dynamic>
  {
    return this.value == null ? null : cast Reflect.field(this.value, key);
  }

  public function getBoolArray(key:String):Array<Bool>
  {
    return this.value == null ? null : cast Reflect.field(this.value, key);
  }
}

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Int;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var validScore:Bool;
	var ?events:Array<SongEventDataRaw>;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Int;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;
	public var events:Array<SongEventDataRaw>;

	public var player1:String = 'bf';
	public var player2:String = 'dad';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = Assets.getText(Paths.json(folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
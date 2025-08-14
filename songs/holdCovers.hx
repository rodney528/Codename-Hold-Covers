import objects.HoldCover;

public var holdCovers:FlxGroup;
function createCover(event):HoldCover {
	var cover:HoldCover = holdCovers.recycle(HoldCover, () -> return new HoldCover(event.note.strumLine, event.direction), true);
	scripts.call('onHoldCoverSpawn', [event, cover]);
	holdCovers.remove(cover);
	return holdCovers.add(cover);
}

function create():Void
	insert(members.indexOf(splashHandler), holdCovers = new FlxGroup());

function onNoteHit(event):Void {
	var strum:Strum = event.note.strumLine.members[event.direction];
	if (event.note.nextSustain != null)
		if (!strum.extra.exists('cover'))
			createCover(event);
	if (strum.extra.exists('cover'))
		if (event.note.animation.name == 'holdend')
			new FlxTimer().start(Conductor.stepCrochet / 1000 * 1.65, () -> strum.extra.get('cover')?.playAnim('end'));
}

function onPlayerMiss(event):Void {
	var strum:Strum = event.note.strumLine.members[event.direction];
	if (strum.extra.exists('cover'))
		strum.extra.get('cover').playAnim('end');
}

static function getHoldCovers():Array<HoldCover>
	return [for (i in holdCovers) if (i.alive && i != null) i];
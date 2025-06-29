import objects.HoldCover;

public var holdCovers:FlxTypedGroup;
function createCover(event):HoldCover {
	var cover:HoldCover = holdCovers.recycle(HoldCover, () -> return new HoldCover().init(event.note.strumLine, event.direction), true);
	if (!cover.extra.exists('baseScale'))
		cover.extra.set('baseScale', cover.scale.x);
	cover.scale.set(cover.extra.get('baseScale') * event.note.strumLine.strumScale, cover.extra.get('baseScale') * event.note.strumLine.strumScale);
	scripts.call('onHoldCoverSpawn', [event, cover]);
	return cover;
}

function create():Void
	insert(members.indexOf(splashHandler), holdCovers = new FlxTypedGroup());

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
	return [for (i in holdCovers) if (i.alive) i];
class HoldCover extends FunkinSprite {
	public var strumLine:StrumLine;
	public var id:Int;
	private function get_strum():Strum
		return strumLine.members[id % strumLine.length];

	private function setupCover():Void {
		cameras = get_strum().lastDrawCameras;
		setPosition(get_strum().x + ((get_strum().width - width) / 2), get_strum().y + ((get_strum().height - height) / 2));
		if (get_strum().extra.exists('theSkinData')) {
			var skinData = get_strum().extra.get('theSkinData');
			x -= (skinData.offsets.splash[0] ?? 0) * strumLine.strumScale;
			y -= (skinData.offsets.splash[1] ?? 0) * strumLine.strumScale;
		}
		scrollFactor.set(get_strum().scrollFactor.x, get_strum().scrollFactor.y);
		visible = get_strum().visible;
		alpha = get_strum().alpha;
	}

	// TODO: Add skin bullshit.
	public function init(strumLine:StrumLine, id:Int):HoldCover {
		this.strumLine = strumLine;
		this.id = id;
		antialiasing = true;
		get_strum().extra.set('cover', this);
		setupCover();
		frames = Paths.getFrames('game/holdcovers/default');
		var color:String = ['Purple', 'Blue', 'Green', 'Red'][id % strumLine.length];
		addAnim('start', 'holdCoverStart' + color, 24, false, true);
		addAnim('hold', 'holdCover' + color, 24, true, true);
		addAnim('end', 'holdCoverEnd' + color, 24, false, true);
		animOffsets.set('start', FlxPoint.get(-30, -21));
		animOffsets.set('hold', FlxPoint.get(-5, 2));
		animOffsets.set('end', FlxPoint.get(37, 27));
		playAnim('start');
		animation.onPlay.add((name:String, forced:Bool, reversed:Bool, frame:Int) -> {
			switch (name) {
				case 'end':
					get_strum().extra.remove('cover');
					if (strumLine.opponentSide != PlayState.opponentMode)
						kill();
			}
		});
		animation.onFinish.add((name:String) -> {
			switch (name) {
				case 'start':
					playAnim('hold');
				case 'end':
					if (strumLine.opponentSide == PlayState.opponentMode)
						kill(); // jic
			}
		});
		return this;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (alive)
			switch (get_strum().getAnim()) {
				case 'confirm':
					setupCover();
			}
	}
}
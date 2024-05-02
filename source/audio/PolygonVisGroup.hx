package audio.visualize;

import flixel.group.FlxTypedGroup;

class PolygonVisGroup extends FlxTypedGroup {
	public var playerVis;
	public var opponentVis;
	public var instVis;

	public function addPlayerVis(visSnd) {
		var vis = new PolygonSpectogram(visSnd);
		super.add(vis);
		this.playerVis = vis;
	}

	public function addOpponentVis(visSnd) {
		var vis = new PolygonSpectogram(visSnd);
		super.add(vis);
		this.opponentVis = vis;
	}

	public function addInstVis(visSnd) {
		var vis = new PolygonSpectogram(visSnd);
		super.add(vis);
		this.instVis = vis;
	}

	public function clearPlayerVis() {
		if (this.playerVis != null) {
			this.remove(this.playerVis);
			this.playerVis.destroy();
			this.playerVis = null;
		}
	}

	public function clearOpponentVis() {
		if (this.opponentVis != null) {
			this.remove(this.opponentVis);
			this.opponentVis.destroy();
			this.opponentVis = null;
		}
	}

	public function clearInstVis() {
		if (this.instVis != null) {
			this.remove(this.instVis);
			this.instVis.destroy();
			this.instVis = null;
		}
	}

	public function clearAllVis() {
		this.clearPlayerVis();
		this.clearOpponentVis();
		this.clearInstVis();
	}

	public function add(vis) {
		var result = super.add(vis);
		return result;
	}

	public function destroy() {
		this.playerVis.destroy();
		this.opponentVis.destroy();
		super.destroy();
	}

	public function new() {
		super();
		this.playerVis = new PolygonSpectogram();
		this.opponentVis = new PolygonSpectogram();
	}
}

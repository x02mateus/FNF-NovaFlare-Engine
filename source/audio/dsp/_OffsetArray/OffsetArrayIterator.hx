package funkin.audio.dsp._OffsetArray;

class OffsetArrayIterator {
	public var array;
	public var offset;
	public var enumeration;

	public function new(array, offset) {
		this.array = array;
		this.offset = offset;
		this.enumeration = 0;
	}
}

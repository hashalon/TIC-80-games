/*
	Contains helper function
*/
class Util {
	
	// return the sorted sequence
	static sortIncreasing (sequence) {
		// add elements in this array
		var array = []
		for (element in sequence) {

			// find where to place the element
			var j = 0
			for (i in 0...array.count) {

				// value in array just got greater !
				if (element < array[i]) {
					j = i
					break
				}
			}
			array.insert(j, element)
		}
		return array
	}
	static sortDecreasing (sequence) {
		// add elements in this array
		var array = []
		for (element in sequence) {

			// find where to place the element
			var j = 0
			for (i in 0...array.count) {

				// value in array just got smaller !
				if (element > array[i]) {
					j = i
					break
				}
			}
			array.insert(j, element)
		}
		return array
	}
}


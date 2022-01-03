
extern "C" void reverse (long * array, long array_size){
	long i=0, j = array_size - 1, temp;
	while(i < array_size/2){
		temp = array[i];
		array[i] = array[j];
		array[j] = temp;
		i++;
		j--;
	}
}
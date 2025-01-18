#include <stdio.h>

#define PREV_FILE_LOC "/tmp/network_down_previous"

int get_previous_value() {
	FILE *f;
	f = fopen(PREV_FILE_LOC, "r");
	if (f == NULL) {
		return 0;
	}
	char buf[100];
	fgets(buf, 100, f);
	int total;
	sscanf(buf, "%d", &total);
	fclose(f);
	return total;
}

void save_new_value(int new_value) {
	FILE *f;
	f = fopen(PREV_FILE_LOC, "w");
	fprintf(f, "%d", new_value);
	fclose(f);
}

int main() {
	int previous_value = get_previous_value();

	FILE *f;
	f = fopen("/sys/class/net/wlp0s20f3/statistics/rx_bytes", "r");
	char buf[100] = {0};
	fgets(buf, 100, f);
	fclose(f);

	int total;
	sscanf(buf, "%d", &total);

	int total_since_last = total - previous_value;

	double mebibytes = (double)total_since_last/(double)1048576/(double)2;

	if (mebibytes < 10) {
		printf("%0.2f MiB/s\n", mebibytes);
	}
	else {
		printf("%0.1f MiB/s\n", mebibytes);
	}

	save_new_value(total);
}

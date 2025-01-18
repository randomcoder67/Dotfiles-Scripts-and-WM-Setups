#include <stdio.h>

#define PREV_FILE_LOC "/tmp/cpu_c_previous"

typedef struct {
	int total;
	int idle;
} Values;

Values get_previous_values() {
	FILE *f;
	f = fopen(PREV_FILE_LOC, "r");
	if (f == NULL) {
		Values prev_values;
		prev_values.total = 0;
		prev_values.idle = 0;
		return prev_values;
	}
	char buf[100];
	fgets(buf, 100, f);
	int total, idle;
	sscanf(buf, "%d %d", &total, &idle);
	Values prev_values;
	prev_values.total = total;
	prev_values.idle = idle;
	fclose(f);
	return prev_values;
}

void save_new_values(Values new_values) {
	FILE *f;
	f = fopen(PREV_FILE_LOC, "w");
	fprintf(f, "%d %d", new_values.total, new_values.idle);
	fclose(f);
}

int main() {
	Values prev_values = get_previous_values();
	
	FILE *f;
	f = fopen("/proc/stat", "r");
	char buf[100] = {0};
	fgets(buf, 100, f);
	//printf("%s\n", buf);
	fclose(f);

	int user, nice, system, idle, iowait, irq, softirq, steal;

	sscanf(buf, "%*s %d %d %d %d %d %d %d %d %*d %*d", &user, &nice, &system, &idle, &iowait, &irq, &softirq, &steal);
	
	//printf("Current: %d %d %d %d %d %d %d %d\n", user, nice, system, idle, iowait, irq, softirq, steal);
	//printf("Old: %d %d\n", prev_values.total, prev_values.idle);

	int total = user + nice + system + idle + iowait + irq + softirq + steal;
	int total_since_last = total - prev_values.total;
	int idle_since_last = idle - prev_values.idle;

	double fraction = (double)idle_since_last/(double)total_since_last;
	double usage = 1 - fraction;
	double percentage = usage * 100;

	//printf("%f %f %f\n", fraction, usage, percentage);
	if (percentage < 9.995) {
		printf("%0.2f%%\n", percentage);
	} else {
		printf("%0.1f%%\n", percentage);
	}

	prev_values.total = total;
	prev_values.idle = idle;

	save_new_values(prev_values);
}

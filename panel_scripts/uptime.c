#include <sys/sysinfo.h>
#include <stdio.h>
#include <time.h>

int main() {
	struct sysinfo info;
	
	if (sysinfo(&info) != 0) {
		printf("Error");
		return 1;
	}
	
	//printf("Uptime: %ld\n", info.uptime);
	//return 0;
	
	
	int hours = info.uptime/3600;
	int minutes = (info.uptime - hours * 3600)/60;
	
	printf("%02d:%02d\n", hours, minutes);

	return 1;
	float f_load = 1.f / (1 << SI_LOAD_SHIFT);
	
	time_t bootTime = time(NULL) - info.uptime + 1;
	struct tm* bootTimeFormatted;
	bootTimeFormatted = localtime(&bootTime);
	
	printf("%s", asctime(bootTimeFormatted));
	time_t a;
	time(&a);
	//printf("%d\n", a);
	
	
	//printf("<tool>Load Average (1m): %0.2f\nLoad Average (5m): %0.2f\nLoad Average (15m): %0.2f</tool>", info.loads[0] * f_load, info.loads[1] * f_load, info.loads[2] * f_load);
	//printf("\n");
}

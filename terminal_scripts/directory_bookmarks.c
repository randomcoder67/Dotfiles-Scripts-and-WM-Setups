#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <linux/limits.h>

#define BOOKMARK_FILE_LOCATION "/.local/share/rc67/script_data/directory_bookmarks.txt"
#define RANGER_BOOKMARK_FILE_LOCATION "/.local/share/rc67/script_data/ranger_directory_bookmarks.conf"

// This script is based on apparix: https://github.com/micans/apparix

static char file_loc[256];
static char ranger_file_loc[256];

typedef struct {
	char bookmark_name[11];
	char directory_name[251];
} Bookmark;

void print_help() {
	printf("Usage:\n");
	printf("  Add New Bookmark: bookmarks add *name*\n");
	printf("  Remove Bookmark: bookmarks remove *name*\n");
	printf("  Get Bookmark: bookmarks get *name*\n");
	printf("  List Bookmarks: bookmarks list\n");
	printf("  Get Bookmark Name of Current Directory: bookmarks cur\n");
}

int get_bookmarks(Bookmark* bookmarks) {
	FILE* f;
	f = fopen(file_loc, "r");
	if (f == NULL) {
		return 0;
	}

	int i = 0;
	char buffer[400];
	
	while (fgets(buffer, sizeof(buffer), f) != NULL) {
		if (i > 99) {
			printf("Error, bookmarks file too big\n");
			break;
		}

		char bookmark_name[11] = {0};
		char directory_name[251] = {0};
		sscanf(buffer, "%s %[^\n]", bookmark_name, directory_name);
		strcpy(bookmarks[i].bookmark_name, bookmark_name);
		strcpy(bookmarks[i].directory_name, directory_name);

		memset(buffer, 0, sizeof(buffer));

		i++;
	}
	return i;
}

void write_bookmarks(Bookmark* bookmarks, int num_bookmarks) {
	FILE* f;
	f = fopen(file_loc, "w");
	for (int i=0; i<num_bookmarks; i++) {
		fprintf(f, "%s %s\n", bookmarks[i].bookmark_name, bookmarks[i].directory_name);
	}
	fclose(f);

	FILE* g;
	g = fopen(ranger_file_loc, "w");
	for (int i=0; i<num_bookmarks; i++) {
		fprintf(g, "map go%s cd %s\n", bookmarks[i].bookmark_name, bookmarks[i].directory_name);
	}
	fclose(g);
}

void add_bookmark(char* to_add) {
	Bookmark bookmarks[100];
	memset(bookmarks, 0, sizeof(bookmarks));
	int num_bookmarks = get_bookmarks(bookmarks);

	if (num_bookmarks > 99) {
		printf("Error, bookmarks full\n");
	}

	char cwd[PATH_MAX] = {0};
	if (getcwd(cwd, sizeof(cwd)) == NULL) {
		printf("Error, unable to get current directory\n");
		return;
	}

	strcpy(bookmarks[num_bookmarks].bookmark_name, to_add);
	strcpy(bookmarks[num_bookmarks].directory_name, cwd);
	
	num_bookmarks++;
	write_bookmarks(bookmarks, num_bookmarks);
}

void resolve_bookmark(char* to_resolve) {
	Bookmark bookmarks[100];
	memset(bookmarks, 0, sizeof(bookmarks));
	int num_bookmarks = get_bookmarks(bookmarks);

	for (int i=0; i<num_bookmarks; i++) {
		if (!strcmp(bookmarks[i].bookmark_name, to_resolve)) {
			printf("%s\n", bookmarks[i].directory_name);
			return;
		}
	}
	
}

void bookmark_for_current_dir() {
	Bookmark bookmarks[100];
	memset(bookmarks, 0, sizeof(bookmarks));
	int num_bookmarks = get_bookmarks(bookmarks);

	char cwd[PATH_MAX] = {0};
	if (getcwd(cwd, sizeof(cwd)) == NULL) {
		printf("Error, unable to get current directory\n");
		return;
	}

	for (int i=0; i<num_bookmarks; i++) {
		if (!strcmp(bookmarks[i].directory_name, cwd)) {
			printf("-(%s)", bookmarks[i].bookmark_name);
			return;
		}
	}
}

void list_bookmarks() {
	Bookmark bookmarks[100];
	memset(bookmarks, 0, sizeof(bookmarks));
	int num_bookmarks = get_bookmarks(bookmarks);

	for (int i=0; i<num_bookmarks; i++) {
		printf("%s: %s\n", bookmarks[i].bookmark_name, bookmarks[i].directory_name);
	}
}

void remove_bookmark(char* to_remove) {
	Bookmark bookmarks[100];
	memset(bookmarks, 0, sizeof(bookmarks));
	int num_bookmarks = get_bookmarks(bookmarks);

	bool move_backwards = false;

	for (int i=0; i<num_bookmarks; i++) {
		if (move_backwards) {
			memset(bookmarks[i-1].bookmark_name, 0, sizeof(bookmarks[i-1].bookmark_name));
			memset(bookmarks[i-1].directory_name, 0, sizeof(bookmarks[i-1].directory_name));
			strcpy(bookmarks[i-1].bookmark_name, bookmarks[i].bookmark_name);
			strcpy(bookmarks[i-1].directory_name, bookmarks[i].directory_name);
		}
		else {
			if (!strcmp(bookmarks[i].bookmark_name, to_remove)) {
				move_backwards = true;
			}
		}
	}
	if (move_backwards) {
		num_bookmarks--;
	}
	write_bookmarks(bookmarks, num_bookmarks);
}

int main(int argc, char* argv[]) {
	if (argc == 1) {
		print_help();
		return 1;
	}

	memset(file_loc, 0, 256);
	memset(ranger_file_loc, 0, 256);
	strcat(strcpy(file_loc, getenv("HOME")), BOOKMARK_FILE_LOCATION);
	strcat(strcpy(ranger_file_loc, getenv("HOME")), RANGER_BOOKMARK_FILE_LOCATION);

	// Add a new bookmark for current directory
	if (!strcmp(argv[1], "add")) {
		if (argc != 3) {
			print_help();
			return 1;
		}
		char* to_add = argv[2];
		add_bookmark(to_add);
	}
	// Get a bookmark
	else if (!strcmp(argv[1], "get")) {
		if (argc != 3) {
			print_help();
			return 1;
		}
		char* to_resolve = argv[2];
		resolve_bookmark(to_resolve);
	}
	// Print the current directory's bookmark, if it exists
	else if (!strcmp(argv[1], "current")) {
		bookmark_for_current_dir();
	}
	// List all bookmarks
	else if (!strcmp(argv[1], "list")) {
		list_bookmarks();
	}
	// Remove a bookmark by name
	else if (!strcmp(argv[1], "remove")) {
		if (argc != 3) {
			print_help();
			return 1;
		}
		char* to_remove = argv[2];
		remove_bookmark(to_remove);
	}
	else {
		print_help();
		return 1;
	}
}

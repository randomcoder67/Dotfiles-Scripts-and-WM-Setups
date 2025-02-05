DESTDIR := $(HOME)/.local/bin
#DESTDIR := output

SH_SCRIPTS := $(wildcard *.sh)

# Remove the .sh extension from the filenames
BASENAMES := $(basename $(SH_SCRIPTS))

normal:
	go build -o downloadtime downloadTime.go
	go build -o metrictime metricTime.go
	go build -o timer timer.go
	go build -o tablealigner tableAligner.go
	gcc directory_bookmarks.c -o directory_bookmarks

install:
	@mkdir -p $(DESTDIR)
	@for script in $(BASENAMES); do \
	    echo "Copying $$script.sh to $(DESTDIR)/$$script"; \
	    cp $$script.sh $(DESTDIR)/$$script; \
	done
	
	cp downloadtime $(DESTDIR)/downloadtime
	cp metrictime $(DESTDIR)/metrictime
	cp timer $(DESTDIR)/timer
	cp tablealigner $(DESTDIR)/tablealigner
	
	cp tagmusic.py $$XDG_DATA_HOME/rc67/data/tagmusic.py
	cp speedwatch.py $(DESTDIR)/speed
	chmod +x $(DESTDIR)/speed
	cp stuff.py $(DESTDIR)/stuff
	chmod +x $(DESTDIR)/stuff
	cp ipod-shuffle-4g.py $$XDG_DATA_HOME/rc67/data/ipod-shuffle-4g.py

	cp directory_bookmarks ${DESTDIR}/directory_bookmarks
	
# Add uninstall

full: normal install clean

clean:
	rm downloadtime
	rm metrictime
	rm timer
	rm directory_bookmarks

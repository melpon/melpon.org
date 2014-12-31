SUBDIRS = src
dist_sysconf_DATA = config.json
sysconfdir = @SYSCONF_DIR@
staticdir = @STATIC_DIR@
databasedir = @DATABASE_DIR@
EXTRA_DIST = config.json.in
config.json: config.json.in
	sed 's#[@]databasedir[@]#$(databasedir)#g' $< > $@.tmp
	sed 's#[@]staticdir[@]#$(staticdir)#g' $@.tmp > $@
	rm $@.tmp

install-data-local:
	$(mkinstalldirs) "$(DESTDIR)$(staticdir)"
	rsync -rLptgok static/ "$(DESTDIR)$(staticdir)/"
	$(mkinstalldirs) -m 755 $(DESTDIR)$(databasedir)

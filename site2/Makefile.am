SUBDIRS = src
dist_sysconf_DATA = config.json header_config.json blog_config.json
sysconfdir = @SYSCONF_DIR@
staticdir = @STATIC_DIR@
databasedir = @DATABASE_DIR@
EXTRA_DIST = config.json.in
config.json: config.json.in
	sed 's#[@]databasedir[@]#$(databasedir)#g' $< > $@.tmp
	sed 's#[@]staticdir[@]#$(staticdir)#g' $@.tmp > $@.tmp2
	sed 's#[@]sysconfdir[@]#$(sysconfdir)#g' $@.tmp2 > $@
	rm $@.tmp
	rm $@.tmp2

install-data-local:
	$(mkinstalldirs) "$(DESTDIR)$(staticdir)"
	rsync -rLptgok static/ "$(DESTDIR)$(staticdir)/"
	$(mkinstalldirs) -m 755 $(DESTDIR)$(databasedir)

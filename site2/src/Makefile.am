AM_CXXFLAGS = -std=c++0x -Wall -Wextra @CXXFLAGS@
bin_PROGRAMS = melpon.org
melpon_org_SOURCES = melpon.org.cpp templates/skin_melpon_org.cpp templates/publication/skin_publication.cpp
# AM_CPPFLAGS = -DBINDIR=\"$(bindir)\" -DSYSCONFDIR=\"$(sysconfdir)\" -DBOOST_SPIRIT_USE_PHOENIX_V3=1 @CPPFLAGS@

SKIN_MELPON_ORG = \
	templates/root.tmpl \
	templates/header.tmpl \
	templates/home.tmpl \
	templates/aboutme.tmpl

SKIN_PUBLICATION = \
	templates/publication/home.tmpl \
	templates/publication/wandbox.tmpl \
	templates/publication/cpprefjp.tmpl \
	templates/publication/kabukiza-wandbox-lt.tmpl \
	templates/publication/auto-lt.tmpl

SKIN_BLOG = \
	templates/blog/blog.tmpl \
	templates/blog/new-blog.tmpl \
	templates/blog/cocos2dx-vector-leak.tmpl \
	templates/blog/cocos2dx-create-func.tmpl \
	templates/blog/put-rss.tmpl \
	templates/blog/ios-consumable-in-app-purchase.tmpl \
	templates/blog/haskell-import-qualified.tmpl \
	templates/blog/cocos2dx-must-not-use-spine-json-h.tmpl

SKIN_MELPON_ORG_HEADER = $(SKIN_MELPON_ORG:%.tmpl=%.h)
SKIN_PUBLICATION_HEADER = $(SKIN_PUBLICATION:%.tmpl=%.h) templates/publication/googleio.h

templates/skin_melpon_org.cpp: $(SKIN_MELPON_ORG) $(SKIN_MELPON_ORG_HEADER)
	@CPPCMS_TMPL_CC@ $(SKIN_MELPON_ORG) -o $@

templates/publication/skin_publication.cpp: $(SKIN_PUBLICATION) $(SKIN_PUBLICATION_HEADER)
	@CPPCMS_TMPL_CC@ $(SKIN_PUBLICATION) -o $@

AM_CXXFLAGS = -std=c++0x -Wall -Wextra @CXXFLAGS@
bin_PROGRAMS = melpon.org
melpon_org_SOURCES = melpon.org.cpp templates/skin_melpon_org.cpp
# AM_CPPFLAGS = -DBINDIR=\"$(bindir)\" -DSYSCONFDIR=\"$(sysconfdir)\" -DBOOST_SPIRIT_USE_PHOENIX_V3=1 @CPPFLAGS@

SKIN_MELPON_ORG = \
	templates/root.tmpl \
	templates/header.tmpl \
	templates/home.tmpl \
	templates/aboutme.tmpl

SKIN_MELPON_ORG_HEADER = $(SKIN_MELPON_ORG:%.tmpl=%.h)

templates/skin_melpon_org.cpp: $(SKIN_MELPON_ORG) $(SKIN_MELPON_ORG_HEADER)
	@CPPCMS_TMPL_CC@ $(SKIN_MELPON_ORG) -o $@

AM_CXXFLAGS = -std=c++0x -Wall -Wextra @CXXFLAGS@
bin_PROGRAMS = melpon.org
melpon_org_SOURCES = melpon.org.cpp skin_melpon_org.cpp
# AM_CPPFLAGS = -DBINDIR=\"$(bindir)\" -DSYSCONFDIR=\"$(sysconfdir)\" -DBOOST_SPIRIT_USE_PHOENIX_V3=1 @CPPFLAGS@
SKIN_MELPON_ORG = root.html.tmpl header.html.tmpl home.html.tmpl

root.html.tmpl: root.h
header.html.tmpl: header.h
home.html.tmpl: home.h

skin_melpon_org.cpp: $(SKIN_MELPON_ORG)
	@CPPCMS_TMPL_CC@ $(SKIN_MELPON_ORG) -o $@

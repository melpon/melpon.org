#line 1 "templates/publication/home.tmpl"
#include "home.h" 
#line 2 "templates/publication/home.tmpl"
namespace melpon_org_publication {
	#line 3 "templates/publication/home.tmpl"
	struct home :public cppcms::base_view
	#line 3 "templates/publication/home.tmpl"
	{
	#line 3 "templates/publication/home.tmpl"
		content::publication::home &content;
	#line 3 "templates/publication/home.tmpl"
		home(std::ostream &_s,content::publication::home &_content): cppcms::base_view(_s),content(_content)
	#line 3 "templates/publication/home.tmpl"
		{
	#line 3 "templates/publication/home.tmpl"
		}
		#line 5 "templates/publication/home.tmpl"
		virtual void render() {
			#line 59 "templates/publication/home.tmpl"
			out()<<"\n"
				"<div class=\"row\">\n"
				"  <div class=\"col-sm-offset-1 col-sm-10\">\n"
				"    <div .page-header>\n"
				"      <h1>公開資料</h1>\n"
				"    </div>\n"
				"    <ul>\n"
				"      <li>\n"
				"        <a href=\"http://d.hatena.ne.jp/melpon/20091212/1260584012\">Boost.Coroutine</a>\n"
				"        （<a href=\"https://sites.google.com/site/boostjp/study_meeting/study1\">Boost.勉強会 #1</a>）\n"
				"      </li>\n"
				"\n"
				"      <li>\n"
				"        <a href=\"http://d.hatena.ne.jp/melpon/20110508/1304813069\">Squirrelと変人の神隠し</a>\n"
				"        （<a href=\"http://atnd.org/events/14697\">関西ゲームプログラミング勉強会 #oustudy</a>）\n"
				"      </li>\n"
				"\n"
				"      <li>\n"
				"        <a href=\"http://www.slideshare.net/melpon/boostinterfaces-na-5179597\">Boost.Interfaces</a>\n"
				"        （<a href=\"https://sites.google.com/site/boostjp/study_meeting/study2\">Boost.勉強会 #2</a>）\n"
				"      </li>\n"
				"\n"
				"      <li>\n"
				"        <a href=\"http://www.slideshare.net/melpon/boosttimer-7068526\">Boost.Timer</a>\n"
				"        （<a href=\"https://sites.google.com/site/boostjp/study_meeting/study4\">Boost.勉強会 #4 東京</a>）\n"
				"      </li>\n"
				"\n"
				"      <li>\n"
				"        <a href=\"http://d.hatena.ne.jp/melpon/20120423/1335187810\">MighttpdのEventSource問題</a>\n"
				"        （<a href=\"http://partake.in/events/76f421e7-c3ca-49bf-b28e-f9ede8032f0b\">(祝) Yesod 1.0 勉強会</a>）\n"
				"      </li>\n"
				"\n"
				"      <li>\n"
				"        <a href=\"https://docs.google.com/presentation/d/1SzdoJYEN-i9asivCtaWLLjtO_T6Ch2KOXbuZs8MY_Tw/edit?usp=sharing\">Effective STL 11</a>\n"
				"        （<a href=\"https://sites.google.com/site/boostjp/study_meeting/study9\">Boost.勉強会 #9 つくば</a>）\n"
				"      </li>\n"
				"\n"
				"      <li>\n"
				"        <a href=@{PWandboxR}>Wandbox を支える技術</a>\n"
				"        （<a href=\"https://sites.google.com/site/boostjp/study_meeting/study13\">Boost.勉強会 #13 仙台</a>）\n"
				"      </li>\n"
				"\n"
				"      <li>\n"
				"        <a href=@{PKabukizaWandboxLtR}>Wandbox の紹介</a>\n"
				"        （<a href=\"http://ch.nicovideo.jp/dwango-engineer/blomaga/ar393478\">歌舞伎座.tech#2</a>）\n"
				"      </li>\n"
				"\n"
				"      <li>\n"
				"        <a href=\"@{PCpprefjpR}\">cpprefjp を支える技術</a>\n"
				"        （<a href=\"https://sites.google.com/site/boostjp/study_meeting/study14\">Boost.勉強会 #14</a>）\n"
				"      </li>\n"
				"    </ul>\n"
				"  </div>\n"
				"</div>\n"
				"";
		#line 59 "templates/publication/home.tmpl"
		} // end of template render
	#line 61 "templates/publication/home.tmpl"
	}; // end of class home
#line 62 "templates/publication/home.tmpl"
} // end of namespace melpon_org_publication
#line 63 "templates/publication/home.tmpl"
namespace {
#line 63 "templates/publication/home.tmpl"
 cppcms::views::generator my_generator; 
#line 63 "templates/publication/home.tmpl"
 struct loader { 
#line 63 "templates/publication/home.tmpl"
  loader() { 
#line 63 "templates/publication/home.tmpl"
   my_generator.name("melpon_org_publication");
#line 63 "templates/publication/home.tmpl"
   my_generator.add_view<melpon_org_publication::home,content::publication::home>("home",true);
#line 63 "templates/publication/home.tmpl"
    cppcms::views::pool::instance().add(my_generator);
#line 63 "templates/publication/home.tmpl"
 }
#line 63 "templates/publication/home.tmpl"
 ~loader() {  cppcms::views::pool::instance().remove(my_generator); }
#line 63 "templates/publication/home.tmpl"
} a_loader;
#line 63 "templates/publication/home.tmpl"
} // anon 

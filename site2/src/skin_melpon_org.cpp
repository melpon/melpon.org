#line 1 "root.html.tmpl"
#include "root.h" 
#line 2 "root.html.tmpl"
namespace melpon_org {
	#line 3 "root.html.tmpl"
	struct root :public cppcms::base_view
	#line 3 "root.html.tmpl"
	{
	#line 3 "root.html.tmpl"
		content::root &content;
	#line 3 "root.html.tmpl"
		root(std::ostream &_s,content::root &_content): cppcms::base_view(_s),content(_content)
	#line 3 "root.html.tmpl"
		{
	#line 3 "root.html.tmpl"
		}
		#line 5 "root.html.tmpl"
		virtual void render() {
			#line 15 "root.html.tmpl"
			out()<<"\n"
				"<!doctype html>\n"
				"<!--[if lt IE 7]> <html class=\"no-js ie6 oldie\" lang=\"en\"> <![endif]-->\n"
				"<!--[if IE 7]>    <html class=\"no-js ie7 oldie\" lang=\"en\"> <![endif]-->\n"
				"<!--[if IE 8]>    <html class=\"no-js ie8 oldie\" lang=\"en\"> <![endif]-->\n"
				"<!--[if gt IE 8]><!-->\n"
				"<html class=\"no-js\" lang=\"en\"> <!--<![endif]-->\n"
				"  <head>\n"
				"    <meta charset=\"UTF-8\">\n"
				"\n"
				"    <title>";
			#line 15 "root.html.tmpl"
			out()<<cppcms::filters::escape(content.title);
			#line 21 "root.html.tmpl"
			out()<<"</title>\n"
				"    <meta name=\"description\" content=\"\">\n"
				"    <meta name=\"author\" content=\"\">\n"
				"\n"
				"    <meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">\n"
				"\n"
				"    ";
			#line 21 "root.html.tmpl"
			includes();
			#line 32 "root.html.tmpl"
			out()<<"\n"
				"\n"
				"    <!--[if lt IE 9]>\n"
				"    <script src=\"http://html5shiv.googlecode.com/svn/trunk/html5.js\"></script>\n"
				"    <![endif]-->\n"
				"\n"
				"    <script>\n"
				"      document.documentElement.className = document.documentElement.className.replace(/\\bno-js\\b/,'js');\n"
				"    </script>\n"
				"  </head>\n"
				"  <body>\n"
				"    ";
			#line 32 "root.html.tmpl"
			{
			#line 32 "root.html.tmpl"
			cppcms::base_content::app_guard _g(content.header,content);
			#line 32 "root.html.tmpl"
			cppcms::views::pool::instance().render("melpon_org","header",out(),content.header);
			#line 32 "root.html.tmpl"
			}
			#line 35 "root.html.tmpl"
			out()<<"\n"
				"    <div id=\"main\" role=\"main\">\n"
				"      <div class=\"container-fluid\">\n"
				"        ";
			#line 35 "root.html.tmpl"
			page_content();
			#line 47 "root.html.tmpl"
			out()<<"\n"
				"      </div>\n"
				"    </div>\n"
				"  </body>\n"
				"  <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you want to support IE 6.  chromium.org/developers/how-tos/chrome-frame-getting-started -->\n"
				"  <!--[if lt IE 7 ]>\n"
				"    <script src=\"//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.3/CFInstall.min.js\"></script>\n"
				"    <script>\n"
				"      window.attachEvent('onload',function(){CFInstall.check({mode:'overlay'})})\n"
				"    </script>\n"
				"  <![endif]-->\n"
				"</html>\n"
				"";
		#line 47 "root.html.tmpl"
		} // end of template render
		#line 49 "root.html.tmpl"
		virtual void includes() {
			#line 51 "root.html.tmpl"
			out()<<"\n"
				"<link rel=\"stylesheet\" href=\"//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css\">\n"
				"<link rel=\"stylesheet\" href=\"";
			#line 51 "root.html.tmpl"
			content.app().mapper().map(out(),"static");
			#line 56 "root.html.tmpl"
			out()<<"/css/root.css\">\n"
				"\n"
				"<script src=\"http://code.jquery.com/jquery-2.1.1.min.js\"></script>\n"
				"<script src=\"//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js\"></script>\n"
				"<script src=\"//platform.twitter.com/widgets.js\"></script>\n"
				"<script src=\"";
			#line 56 "root.html.tmpl"
			content.app().mapper().map(out(),"static");
			#line 61 "root.html.tmpl"
			out()<<"/js/jquery.url.js\"></script>\n"
				"\n"
				"<script>\n"
				"</script>\n"
				"\n"
				"<script src=\"";
			#line 61 "root.html.tmpl"
			content.app().mapper().map(out(),"static");
			#line 62 "root.html.tmpl"
			out()<<"/js/root.js\"></script>\n"
				"";
		#line 62 "root.html.tmpl"
		} // end of template includes
		#line 64 "root.html.tmpl"
		virtual void page_content() {
			#line 65 "root.html.tmpl"
			out()<<"\n"
				"";
		#line 65 "root.html.tmpl"
		} // end of template page_content
	#line 67 "root.html.tmpl"
	}; // end of class root
#line 68 "root.html.tmpl"
} // end of namespace melpon_org
#line 1 "header.html.tmpl"
#include "header.h" 
#line 2 "header.html.tmpl"
namespace melpon_org {
	#line 3 "header.html.tmpl"
	struct header :public cppcms::base_view
	#line 3 "header.html.tmpl"
	{
	#line 3 "header.html.tmpl"
		content::header &content;
	#line 3 "header.html.tmpl"
		header(std::ostream &_s,content::header &_content): cppcms::base_view(_s),content(_content)
	#line 3 "header.html.tmpl"
		{
	#line 3 "header.html.tmpl"
		}
		#line 5 "header.html.tmpl"
		virtual void render() {
			#line 15 "header.html.tmpl"
			out()<<"\n"
				"<header>\n"
				"  <div class=\"navbar\">\n"
				"    <div class=\"navbar-inner\">\n"
				"      <div class=\"container\">\n"
				"        <button type=\"button\" class=\"btn btn-navbar\" data-toggle=\"collapse\" data-target=\".nav-collapse\">\n"
				"          <span class=\"icon-bar\"></span>\n"
				"          <span class=\"icon-bar\"></span>\n"
				"          <span class=\"icon-bar\"></span>\n"
				"        </button>\n"
				"        <a class=\"brand\" href=\"";
			#line 15 "header.html.tmpl"
			content.app().mapper().map(out(),"root");
			#line 18 "header.html.tmpl"
			out()<<"\">melpon.org</a>\n"
				"        <div class=\"nav-collapse collapse\">\n"
				"          <ul class=\"nav\">\n"
				"            ";
			#line 18 "header.html.tmpl"
			if((content.headers.array()).begin()!=(content.headers.array()).end()) {
				#line 19 "header.html.tmpl"
				out()<<"\n"
					"              ";
				#line 19 "header.html.tmpl"
				for(CPPCMS_TYPEOF((content.headers.array()).begin()) header_ptr=(content.headers.array()).begin(),header_ptr_end=(content.headers.array()).end();header_ptr!=header_ptr_end;++header_ptr) {
				#line 19 "header.html.tmpl"
				CPPCMS_TYPEOF(*header_ptr) &header=*header_ptr;
					#line 21 "header.html.tmpl"
					out()<<"\n"
						"                <li\n"
						"                  ";
					#line 21 "header.html.tmpl"
					if(header["name"].str() == content.header_name) {
						#line 23 "header.html.tmpl"
						out()<<"\n"
							"                    class=\"active\"\n"
							"                  ";
					#line 23 "header.html.tmpl"
					} // endif
					#line 25 "header.html.tmpl"
					out()<<"\n"
						"                >\n"
						"                  <a href=\"";
					#line 25 "header.html.tmpl"
					content.app().mapper().map(out(), header["map"].str()); 
					#line 26 "header.html.tmpl"
					out()<<"\">\n"
						"                    ";
					#line 26 "header.html.tmpl"
					out()<<content.getstr(header,"name");
					#line 29 "header.html.tmpl"
					out()<<"\n"
						"                  </a>\n"
						"                </li>\n"
						"              ";
				#line 29 "header.html.tmpl"
				} // end of item
				#line 30 "header.html.tmpl"
				out()<<"\n"
					"            ";
			#line 30 "header.html.tmpl"
			}
			#line 37 "header.html.tmpl"
			out()<<"\n"
				"          </ul>\n"
				"        </div>\n"
				"      </div>\n"
				"    </div>\n"
				"  </div>\n"
				"</header>\n"
				"";
		#line 37 "header.html.tmpl"
		} // end of template render
	#line 39 "header.html.tmpl"
	}; // end of class header
#line 40 "header.html.tmpl"
} // end of namespace melpon_org
#line 1 "home.html.tmpl"
#include "home.h" 
#line 2 "home.html.tmpl"
namespace melpon_org {
	#line 3 "home.html.tmpl"
	struct home :public root
	#line 3 "home.html.tmpl"
	{
	#line 3 "home.html.tmpl"
		content::home &content;
	#line 3 "home.html.tmpl"
		home(std::ostream &_s,content::home &_content): root(_s,_content),content(_content)
	#line 3 "home.html.tmpl"
		{
	#line 3 "home.html.tmpl"
		}
		#line 5 "home.html.tmpl"
		virtual void page_content() {
			#line 46 "home.html.tmpl"
			out()<<"\n"
				"<div class=\"container-fluid\">\n"
				"  <div class=\"span12\">\n"
				"    <div class=\"page-header\">\n"
				"      <h1>Licensed by Meatware</h1>\n"
				"    <p><a href=@{AboutmeR}>めるぽん</a>の個人ページです。</p>\n"
				"\n"
				"    <div class=\"page-header\">\n"
				"      <h1>公開しているサイト</h1>\n"
				"    </div>\n"
				"\n"
				"    <h3>\n"
				"      <a href=\"http://melpon.org/wandbox\">Wandbox</a>\n"
				"      <small> ( <a href=\"https://github.com/melpon/wandbox\">source</a> )</small>\n"
				"    </h3>\n"
				"    <div class=\"description\">\n"
				"      <p>オンラインコンパイラみたいなやつ。C++ の充実度が高い。</p>\n"
				"      <p><a href=\"https://twitter.com/kikairoya\">@kikairoya</a> と２人で作ってます。コントリビュート歓迎。</p>\n"
				"    </div>\n"
				"\n"
				"    <h3><a href=\"http://d.hatena.ne.jp/melpon\">旧ブログ</a></h3>\n"
				"    <div class=\"description\">\n"
				"      <p>旧ブログ。</p>\n"
				"    </div>\n"
				"\n"
				"    <h3>\n"
				"      <a href=\"http://melpon.org/mpidl\">MessagePack IDL Code Generator</a>\n"
				"      <small> ( <a href=\"https://github.com/melpon/mpidl-web\">source</a> )</small>\n"
				"    </h3>\n"
				"    <div class=\"description\">\n"
				"      <p>MessagePack 用の IDL を作ってくれるサイト。</p>\n"
				"      <p>単に <a href=\"https://github.com/msgpack/msgpack-haskell/tree/master/msgpack-idl\">msgpack-idl</a> をサイトに組み込んだだけ。</p>\n"
				"    </div>\n"
				"\n"
				"    <h3><a href=\"http://melpon.org/munin\">Munin for melpon.org</a></h3>\n"
				"    <div class=\"description\">\n"
				"      <p>melpon.org の負荷を確認するだけ。</p>\n"
				"    </div>\n"
				"  </div>\n"
				"</div>\n"
				"\n"
				"";
		#line 46 "home.html.tmpl"
		} // end of template page_content
	#line 48 "home.html.tmpl"
	}; // end of class home
#line 49 "home.html.tmpl"
} // end of namespace melpon_org
#line 50 "home.html.tmpl"
namespace {
#line 50 "home.html.tmpl"
 cppcms::views::generator my_generator; 
#line 50 "home.html.tmpl"
 struct loader { 
#line 50 "home.html.tmpl"
  loader() { 
#line 50 "home.html.tmpl"
   my_generator.name("melpon_org");
#line 50 "home.html.tmpl"
   my_generator.add_view<melpon_org::root,content::root>("root",true);
#line 50 "home.html.tmpl"
   my_generator.add_view<melpon_org::header,content::header>("header",true);
#line 50 "home.html.tmpl"
   my_generator.add_view<melpon_org::home,content::home>("home",true);
#line 50 "home.html.tmpl"
    cppcms::views::pool::instance().add(my_generator);
#line 50 "home.html.tmpl"
 }
#line 50 "home.html.tmpl"
 ~loader() {  cppcms::views::pool::instance().remove(my_generator); }
#line 50 "home.html.tmpl"
} a_loader;
#line 50 "home.html.tmpl"
} // anon 

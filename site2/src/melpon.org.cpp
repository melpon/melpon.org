#include <iostream>
#include <fstream>
#include <random>
#include "libs.h"
#include "templates/root.h"
#include "templates/home.h"
#include "templates/aboutme.h"
#include "templates/publication/home.h"

namespace cppcms {
    template<>
    struct serialization_traits<json::value> {
        static void load(const std::string& serialized_object, json::value& real_object) {
            std::stringstream ss(serialized_object);
            real_object.load(ss, true, nullptr);
        }
        static void save(const json::value& real_object, std::string& serialized_object) {
            std::stringstream ss;
            real_object.save(ss, cppcms::json::compact);
            serialized_object = ss.str();
        }
    };
}

class yesodbookjp : public cppcms::application {
public:
    yesodbookjp(cppcms::service &srv) : cppcms::application(srv) {
        dispatcher().assign("/?", &yesodbookjp::home, this);
        mapper().assign("home", "");
    }

    void home() {
    }
};

class publication : public cppcms::application {
public:
    publication(cppcms::service &srv) : cppcms::application(srv) {
        dispatcher().assign("/?", &publication::home, this);
        mapper().assign("home", "");
    }

    void home() {
        content::publication::home c;
        c.title = "公開資料";
        c.content_skin = "melpon_org_publication";
        c.content_view = "home";
        c.header.header_name = "publication";
        render("melpon_org", "root", c);
    }
};

class melpon_org : public cppcms::application {
public:
    melpon_org(cppcms::service &srv) : cppcms::application(srv) {
        attach(
            new yesodbookjp(srv),
            "yesodbookjp", "/yesodbookjp{1}",
            "/yesodbookjp(/(.*))?", 1);
        attach(
            new publication(srv),
            "publication", "/publication{1}",
            "/publication(/(.*))?", 1);

        // static file is served by nginx on production server.
        dispatcher().assign("/static/(([a-zA-Z0-9_\\-]+/)*+([a-zA-Z0-9_\\-]+)\\.(js|css|png|gif))", &melpon_org::serve_file_for_debug, this, 1, 4);
        dispatcher().assign("/static/(js/jquery.cookie.(js))", &melpon_org::serve_file_for_debug, this, 1, 2);
        dispatcher().assign("/static/(js/jquery.url.(js))", &melpon_org::serve_file_for_debug, this, 1, 2);
        mapper().assign("static", "/static");

        dispatcher().assign("/aboutme/?", &melpon_org::aboutme, this);
        mapper().assign("aboutme", "/aboutme");

        dispatcher().assign("/?", &melpon_org::home, this);
        mapper().assign("home", "");

        mapper().root(srv.settings()["application"]["root"].str());
    }

    void home() {
        content::home c;
        c.title = "Home";
        c.content_skin = "melpon_org";
        c.content_view = "home";
        c.header.header_name = "home";
        render("root", c);
    }

    void aboutme() {
        content::aboutme c;
        c.title = "About Me";
        c.content_skin = "melpon_org";
        c.content_view = "aboutme";
        c.header.header_name = "aboutme";
        render("root", c);
    }

    void serve_file_for_debug(std::string file_name, std::string ext) {
        auto static_dir = service().settings()["application"]["static_dir"].str();
        std::ifstream f((static_dir + "/" + file_name).c_str());

        if (!f) {
            response().status(404);
        } else {
            std::string content_type =
                ext == "js" ? "text/javascript" :
                ext == "css" ? "text/css" :
                ext == "gif" ? "image/gif" :
                ext == "png" ? "image/png" :
                               "";
            response().content_type(content_type);
            response().out() << f.rdbuf();
        }
    }
};

int main(int argc, char** argv) try {
    cppcms::service service(argc, argv);

    service.applications_pool().mount(
        cppcms::applications_factory<melpon_org>()
    );
    service.run();
} catch (std::exception const &e) {
    std::cerr << e.what() << std::endl;
}


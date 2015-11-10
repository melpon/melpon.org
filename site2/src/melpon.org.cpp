#include <iostream>
#include <fstream>
#include <random>
#include "libs.h"
#include "templates/root.h"
#include "templates/home.h"
#include "templates/aboutme.h"
#include "templates/publication/home.h"
#include "templates/publication/wandbox.h"
#include "templates/publication/cpprefjp.h"
#include "templates/publication/kabukiza-wandbox-lt.h"
#include "templates/publication/auto-lt.h"

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

class blog : public cppcms::application {
public:
    blog(cppcms::service &srv) : cppcms::application(srv) {
        dispatcher().assign("/?", &blog::home, this);
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
        dispatcher().assign("/wandbox/?", &publication::wandbox, this);
        mapper().assign("wandbox", "/wandbox");
        dispatcher().assign("/cpprefjp/?", &publication::cpprefjp, this);
        mapper().assign("cpprefjp", "/cpprefjp");
        dispatcher().assign("/kabukiza-wandbox-lt/?", &publication::kabukiza_wandbox_lt, this);
        mapper().assign("kabukiza-wandbox-lt", "/kabukiza-wandbox-lt");
        dispatcher().assign("/auto-lt/?", &publication::auto_lt, this);
        mapper().assign("auto-lt", "/auto-lt");
    }

    void home() {
        content::publication::home c;
        c.title = "公開資料";
        c.content_skin = "melpon_org_publication";
        c.content_view = "home";
        c.header.header_name = "publication";
        render("melpon_org", "root", c);
    }

    void wandbox() {
        content::publication::wandbox c;
        render("melpon_org_publication", "wandbox", c);
    }

    void cpprefjp() {
        content::publication::cpprefjp c;
        render("melpon_org_publication", "cpprefjp", c);
    }

    void kabukiza_wandbox_lt() {
        content::publication::kabukiza_wandbox_lt c;
        render("melpon_org_publication", "kabukiza_wandbox_lt", c);
    }

    void auto_lt() {
        content::publication::auto_lt c;
        render("melpon_org_publication", "auto_lt", c);
    }
};

class melpon_org : public cppcms::application {
public:
    melpon_org(cppcms::service &srv) : cppcms::application(srv) {
        attach(
            new publication(srv),
            "publication", "/pub{1}",
            "/pub(/(.*))?", 1);
        attach(
            new blog(srv),
            "blog", "/blog{1}",
            "/blog(/(.*))?", 1);

        // static file is served by nginx on production server.
        dispatcher().assign("/static/(.+)", &melpon_org::serve_file_for_debug, this, 1);
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
        render("melpon_org", "root", c);
    }

    void aboutme() {
        content::aboutme c;
        c.title = "About Me";
        c.content_skin = "melpon_org";
        c.content_view = "aboutme";
        c.header.header_name = "aboutme";
        render("melpon_org", "root", c);
    }

    std::string get_extension(std::string file_name) {
        auto pos = file_name.find_last_of('/');
        if (pos != std::string::npos)
            file_name = file_name.substr(pos);
        pos = file_name.find_last_of('.');
        if (pos != std::string::npos)
            return file_name.substr(pos + 1);
        return "";
    }
    void serve_file_for_debug(std::string file_name) {
        auto static_dir = service().settings()["application"]["static_dir"].str();
        std::ifstream f((static_dir + "/" + file_name).c_str());

        if (!f) {
            response().status(404);
        } else {
            std::string ext = get_extension(file_name);
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


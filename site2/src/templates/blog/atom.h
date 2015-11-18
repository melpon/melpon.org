#ifndef BLOG_ATOM_H_INCLUDED
#define BLOG_ATOM_H_INCLUDED

#include <string>
#include <vector>
#include <fstream>
#include "libs.h"
#include "blog.h"
#include "../header.h"

namespace content {
namespace blog {

    struct atom_entry {
    public:
        std::string title;
        std::string link;
        std::string id;
        std::string updated;
        std::string content;
        std::string author_name;
        std::string author_email;
    };

    struct atom_feed {
        std::string title;
        std::string link;
        std::string updated;
        std::string id;
        std::vector<atom_entry> entries;
    };

    struct atom_content : public cppcms::base_content {
        atom_feed feed;
        static std::string make_abs_url(cppcms::application& app, std::string mapped_url) {
            auto& settings = app.service().settings()["application"];
            auto url = settings["scheme"].str() + "://" + settings["domain"].str();
            url += "/" + mapped_url;
            return url;
        }
        static atom_content make(cppcms::application& app, ::content::blog::blog& b, std::function< ::content::blog::blog_content (std::string)> make_blog_content) {
            atom_content c;
            c.app(app);
            c.feed.title = "Blog :: Meatware";
            std::stringstream ss;
            app.mapper().map(ss, "home");
            c.feed.link = make_abs_url(app, ss.str());
            auto& head = b.contents.front();
            c.feed.updated = head.datetime;
            c.feed.id = c.feed.link;

            for (auto& content: b.contents) {
                atom_entry e;
                e.title = content.title;

                std::stringstream ss;
                app.mapper().map(ss, "single", cppcms::filters::urlencode(content.url));
                e.link = make_abs_url(app, ss.str());

                e.id = "entry:" + content.datetime + "," + content.url;
                e.updated = content.datetime;

                std::stringstream ss2;
                auto bc = make_blog_content(content.url);
                app.render("melpon_org_blog", content.template_name, ss2, bc);
                e.content = ss2.str();

                e.author_name = "melpon";
                e.author_email = "shigemasa7watanabe+blogfeed@gmail.com";

                c.feed.entries.push_back(e);
            }

            return c;
        }
    };
}}

#endif // BLOG_ATOM_H_INCLUDED

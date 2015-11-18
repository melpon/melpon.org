#ifndef BLOG_BLOG_H_INCLUDED
#define BLOG_BLOG_H_INCLUDED

#include <string>
#include <vector>
#include <fstream>
#include "libs.h"
#include "../header.h"

namespace content {
namespace blog {

    class content {
    public:
        std::string datetime;
        std::vector<std::string> tags;
        std::string url;
        std::string title;
        std::string template_name;
    };

    class blog {
    public:
        std::string template_prefix;
        std::vector<content> contents;

        void init(cppcms::json::value& json) {
            template_prefix = json["template_prefix"].str();
            for (auto&& x: json["contents"].array()) {
                content c;
                c.datetime = x["datetime"].str();
                for (auto&& y: x["tags"].array())
                    c.tags.push_back(y.str());
                c.url = x["url"].str();
                c.title = x["title"].str();
                c.template_name = x["template_name"].str();
                contents.push_back(c);
            }
            std::sort(contents.begin(), contents.end(), [](const content& a, const content& b) { return a.datetime > b.datetime; });
        }
    };

    struct blog_content : public cppcms::base_content {
        std::string title;
        std::vector<content> contents;
        std::vector<std::string> tags;
        blog blog_data;
        ::content::header header;
        std::string pager_type;
        std::vector<content> prev_contents;
        std::vector<content> next_contents;
        std::string prev_content_url;
        std::string next_content_url;

        blog& get_blog() {
            static blog blog_ = load_blog();
            return blog_;
        }

        content url_content(std::string url) {
            for (auto&& c: get_blog().contents) {
                if (c.url == url) return c;
            }
            // not found
            throw std::exception();
        }
        std::vector<content> url_contents(std::string url) {
            return std::vector<content>(1, url_content(url));
        }
        std::vector<content> tagged_contents(std::string tag) {
            std::vector<content> cs;
            for (auto&& c: get_blog().contents) {
                for (auto&& t: c.tags) {
                    if (t == tag) {
                        cs.push_back(c);
                        break;
                    }
                }
            }
            return cs;
        }
        std::vector<content> recent_contents() {
            std::vector<content> cs;
            for (auto&& c: get_blog().contents) {
                if (cs.size() >= 5) break;
                cs.push_back(c);
            }
            return cs;
        }
        std::vector<content> recent_contents(std::string url) {
            std::vector<content> cs;
            bool found = false;
            for (auto&& c: get_blog().contents) {
                if (cs.size() >= 5) break;
                if (found) {
                    cs.push_back(c);
                } else {
                    if (c.url == url) {
                        cs.push_back(c);
                        found = true;
                    }
                }
            }
            return cs;
        }
        std::vector<std::string> get_tags() {
            std::set<std::string> ts;
            for (auto&& c: get_blog().contents) {
                for (auto&& t: c.tags) {
                    ts.insert(t);
                }
            }
            // sort
            std::vector<std::string> ts2(ts.begin(), ts.end());
            std::sort(ts2.begin(), ts2.end());
            return ts2;
        }
        std::vector<content> get_prev_contents(const std::vector<content>& contents) {
            std::vector<content> rs;
            if (contents.empty()) return rs;
            auto it = std::find_if(get_blog().contents.begin(), get_blog().contents.end(), [&contents](const content& c) { return c.url == contents.back().url; });
            if (it == get_blog().contents.end()) return rs;
            if (it == get_blog().contents.end() - 1) return rs;
            std::copy(++it, get_blog().contents.end(), std::back_inserter(rs));
            return rs;
        }
        std::vector<content> get_next_contents(const std::vector<content>& contents) {
            std::vector<content> rs;
            if (contents.empty()) return rs;
            auto it = std::find_if(get_blog().contents.begin(), get_blog().contents.end(), [&contents](const content& c) { return c.url == contents.front().url; });
            if (it == get_blog().contents.end()) return rs;
            if (it == get_blog().contents.begin()) return rs;
            std::copy(get_blog().contents.begin(), it, std::back_inserter(rs));
            return rs;
        }

    private:
        blog load_blog() {
            cppcms::json::value blog_json;
            auto blog_config_path = app().service().settings()["application"]["blog_config"].str();
            std::ifstream fs(blog_config_path.c_str());
            blog_json.load(fs, true);
            blog b;
            b.init(blog_json);
            return b;
        }
    };
}}

#endif // BLOG_BLOG_H_INCLUDED

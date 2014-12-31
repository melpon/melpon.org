#ifndef HEADER_H_INCLUDED
#define HEADER_H_INCLUDED

#include <string>
#include <fstream>
#include "libs.h"

namespace content {
    struct header : public cppcms::base_content {
        std::string header_name;

        cppcms::json::value load_headers() {
            cppcms::json::value headers;
            auto header_config_path = app().service().settings()["application"]["header_config"].str();
            std::ifstream fs(header_config_path.c_str());
            headers.load(fs, true);
            return headers;
        }
        cppcms::json::value& headers() {
            static cppcms::json::value headers_ = load_headers();
            return headers_;
        }

        void map(std::ostream& out, cppcms::json::value& header) {
            auto name = header["name"].str();
            if (name == "publication" || name == "yesodbookjp") {
                app().mapper().topmost().child(name).map(out, "home");
            } else {
                app().mapper().topmost().map(out, name);
            }
        }


        std::string getstr(cppcms::json::value& v, const std::string& key) {
            return v[key].str();
        }
    };
}

#endif // HEADER_H_INCLUDED

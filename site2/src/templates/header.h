#ifndef HEADER_H_INCLUDED
#define HEADER_H_INCLUDED

#include <string>
#include <fstream>
#include "libs.h"

namespace content {
    struct header : public cppcms::base_content {
        std::string header_name;

        cppcms::json::value& headers() {
            static cppcms::json::value headers_;
            if (headers_.is_undefined()) {
                auto header_config_path = app().service().settings()["application"]["header_config"].str();
                std::ifstream fs(header_config_path.c_str());
                headers_.load(fs, true);
            }
            return headers_;
        }

        std::string getstr(cppcms::json::value& v, const std::string& key) {
            return v[key].str();
        }
    };
}

#endif // HEADER_H_INCLUDED

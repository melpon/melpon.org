#ifndef HEADER_H_INCLUDED
#define HEADER_H_INCLUDED

#include <string>
#include "libs.h"

namespace content {
    struct header : public cppcms::base_content {
        cppcms::json::value headers;
        std::string header_name;

        std::string getstr(cppcms::json::value& v, const std::string& key) {
            return v[key].str();
        }
    };
}

#endif // HEADER_H_INCLUDED

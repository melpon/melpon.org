#ifndef ROOT_H_INCLUDED
#define ROOT_H_INCLUDED

#include <string>
#include "libs.h"
#include "header.h"

namespace content {
    struct root : public cppcms::base_content {
        std::string title;
        std::string content_skin;
        std::string content_view;
        content::header header;
    };
}

#endif // ROOT_H_INCLUDED

#ifndef PUBLICATION_WANDBOX_H_INCLUDED
#define PUBLICATION_WANDBOX_H_INCLUDED

#include <string>
#include <functional>
#include <tuple>
#include "libs.h"

namespace content {
namespace publication {
    struct wandbox : public cppcms::base_content {
        typedef cppcms::json::value index_t;
        typedef std::function<std::string (const index_t&, const char*)> index_func_t;

        cppcms::json::value find(const cppcms::json::value& json, const char* name) {
            for (auto&& v: json.array()) {
                if (v["name"].str() == name) {
                    return v;
                }
            }
            return cppcms::json::value();
        }
        std::vector<cppcms::json::value> get_index_list(const cppcms::json::value& json, const char* name) {
            std::vector<cppcms::json::value> indices;
            get_index_list_(json, name, indices);
            return indices;
        }
        bool get_index_list_(const cppcms::json::value& json, const char* name, std::vector<cppcms::json::value>& indices) {
            auto value = find(json, name);
            if (!value.is_undefined()) {
                indices.push_back(value);
                return true;
            } else {
                for (auto&& val: json.array()) {
                    auto& v = val.find("contents");
                    if (!v.is_undefined()) {
                        indices.push_back(val);
                        if (get_index_list_(v, name, indices)) {
                            return true;
                        } else {
                            indices.pop_back();
                        }
                    }
                }
            }
            // not found
            return false;
        }

        std::string get_title(const index_t& json, const char* name) {
            if (name == nullptr) {
                return json["title"].str();
            } else {
                auto xs = get_index_list(json["contents"], name);
                std::string result;
                if (xs.empty()) return result;
                result += xs.front()["title"].str();
                for (int i = 1; i < (int)xs.size(); i++)
                    result += " - " + xs[i]["title"].str();
                return result;
            }
        }

        std::tuple<bool, std::string> make_ul(const cppcms::json::value& json, const char* name) {
            std::string result = "<ul>";
            bool matched = false;
            for (auto&& v: json.array()) {
                auto p = make_li(v, name);
                if (std::get<0>(p)) {
                    matched = true;
                }
                result += std::get<1>(p);
            }
            result += "</ul>";
            return std::make_tuple(matched, result);
        }
        std::tuple<bool, std::string> make_li(const cppcms::json::value& json, const char* name) {
            auto& v = json.find("contents");
            if (v.is_undefined()) {
                bool matched = name == nullptr || name == json["name"].str();
                std::string css = matched ? "visible-text" : "non-visible-text";
                return std::make_tuple(matched, "<li class=\"" + css + "\">" + json["title"].str() + "</li>");
            } else {
                auto p = make_ul(v, name);
                bool matched = std::get<0>(p) || name == nullptr || name == json["name"].str();
                std::string css = matched ? "visible-text" : "non-visible-text";
                return std::make_tuple(matched, "<li class=\"" + css + "\">" + json["title"].str() + std::get<1>(p) + "</li>");
            }
        }

        index_func_t index_slide() {
            return [this](const index_t& json, const char* name) {
                auto title = get_title(json, name);
                auto ul = std::get<1>(make_ul(json["contents"], name));
                return R"raw(
                  <slide class="index">
                    <hgroup>
                      <h2>
                        )raw" + title + R"raw(
                      </h2>
                    </hgroup>
                    <article>
                      )raw" + ul + R"raw(
                    </article>
                  </slide>
                )raw";
            };
        }

        index_func_t index_title() {
            return [this](const index_t& json, const char* name) {
                auto title = get_title(json, name);
                return title;
            };
        }

        static index_t internal_json() {
            static const char* internal_json_str = R"raw(
              { "title": "目次"
              , "contents":
                [ { "name": "relation"
                  , "title": "牛舎と犬小屋の関係"
                  }
                , { "name": "cattleshed"
                  , "title": "牛舎"
                  }
                , { "name": "kennel"
                  , "title": "犬小屋"
                  , "contents":
                    [ { "name": "yesod"
                      , "title": "Yesod"
                      }
                    , { "name": "templates"
                      , "title": "Templates"
                      }
                    , { "name": "eventsource"
                      , "title": "EventSource"
                      }
                    ]
                  }
                , { "name": "kurou"
                  , "title": "苦労話"
                  }
                ]
              }
            )raw";
            std::stringstream ss(internal_json_str);
            index_t json;
            json.load(ss, true, nullptr);
            return json;
        }
        std::string internal(index_func_t func, const char* str) {
            static index_t json = internal_json();
            return func(json, str);
        }

        static index_t server_json() {
            static const char* server_json_str = R"raw(
              { "title": "目次"
              , "contents":
                [ { "name": "all"
                  , "title": "全体構成"
                  , "contents":
                    [ { "name": "mighttpd"
                      , "title": "Mighttpd"
                      }
                    ]
                  }
                , { "name": "management"
                  , "title": "サーバ管理"
                  , "contents":
                    [ { "name": "chef"
                      , "title": "Chef"
                      }
                    , { "name": "deploy"
                      , "title": "Deploy"
                      }
                    ]
                  }
                ]
              }
            )raw";
            std::stringstream ss(server_json_str);
            index_t json;
            json.load(ss, true, nullptr);
            return json;
        }
        std::string server(index_func_t func, const char* str) {
            static index_t json = server_json();
            return func(json, str);
        }

        const char* source_hamlet_sample1() {
return R"raw(
<div .span2 #editor-settings>
  <label .row-fluid>choose key binding:
  <select .span12 size=3>
    <option value="ace" selected>default
    <option value="vim">Vim
    <option value="emacs">Emacs
  <label .checkbox>
    <input type="checkbox" value="use-legacy-editor">Use Legacy Editor)raw";
        }

        const char* source_hamlet_sample1_html() {
return R"raw(
<div class="span2" id="editor-settings">
  <label class="row-fluid">choose key binding:</label>
  <select class="span12" size=3>
    <option value="ace" selected>default</option>
    <option value="vim">Vim</option>
    <option value="emacs">Emacs</option>
  </select>
  <label class="checkbox">
    <input type="checkbox" value="use-legacy-editor">Use Legacy Editor</input>
  </label>
</div>)raw";
        }

        const char* source_hamlet_sample2() {
return R"raw(
<div .row-fluid>
  <div #compile-options>
    $forall info <- compilerInfos
      <div compiler="#{verName $ ciVersion info}">
        $forall sw <- ciSwitches info
          ^{makeSwitch (verName (ciVersion info)) sw})raw";
        }

        const char* source_lucius_sample() {
return R"raw(
@textcolor: #ccc;
body {
  color: #{textcolor};
  a {
    color: #{textcolor};
  }
})raw";
        }

        const char* source_lucius_sample_css() {
return R"raw(
body {
  color: #ccc;
}
body a {
  color: #ccc;
})raw";
        }

        const char* source_julius_sample() {
return R"raw(
$(function() {
  var result_container = new ResultContainer('#result-container')
  result_container.onfinish = function() {
    $('#compile').show();
    $('#compiling').hide();
  };
  ...
  var compiler = new Compiler('#compiler', '#compile-options');
  compiler.set_compiler(#{defaultCompiler});
});)raw";
        }

        const char* source_loop_sample() {
return R"raw(
main = mapM_ print [1..])raw";
        }
    };
}}

#endif // PUBLICATION_WANDBOX_H_INCLUDED

#ifndef PUBLICATION_GOOGLEIO_H_INCLUDED
#define PUBLICATION_GOOGLEIO_H_INCLUDED

#include <string>
#include <functional>
#include <tuple>
#include "libs.h"

namespace content {
namespace publication {
    struct googleio : public cppcms::base_content {
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

        std::string get_shorttitle(const index_t& json, const char* name) {
            if (name == nullptr) {
                return json["title"].str();
            } else {
                auto xs = get_index_list(json["contents"], name);
                if (xs.empty()) return "";
                return xs.back()["title"].str();
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

        index_func_t index_slide_shorttitle() {
            return [this](const index_t& json, const char* name) {
                auto title = get_shorttitle(json, name);
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

        index_func_t index_shorttitle() {
            return [this](const index_t& json, const char* name) {
                auto title = get_shorttitle(json, name);
                return title;
            };
        }

        std::string to_takahashi(std::string message) {
            return R"raw(
              <slide>
                <article class="takahashi flexbox vcenter">
                  <h1>
                    )raw" + message + R"raw(
                  </h1>
                </article>
              </slide>
            )raw";
        }

        // Important version
        std::string to_takahashi_i(std::string message) {
            return R"raw(
              <slide>
                <article class="takahashi important flexbox vcenter">
                  <h1 class="red">
                    )raw" + message + R"raw(
                  </h1>
                </article>
              </slide>
            )raw";
        }
    };
}}

#endif // PUBLICATION_GOOGLEIO_H_INCLUDED
